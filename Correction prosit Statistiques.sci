// Prosit Statistiques
// v1.0 V. Levorato $ 06/01/2015
// v1.1 Y. Cherfaoui $ 20/06/2016
// v1.2 R. Bello $ 28/06/2016

//#### Service Informatique
// Lois de probabilités

disp("Exercice 1 - Service Informatique");

// Chargement des données dans une matrice
data=read_csv('charge_we.csv', ';');

// Convertir le string vers le double
data=strtod(data)

// Moyenne de la matrice
m=mean(data)

// Ecart-type des termes de la matrice
sigma=stdev(data)

// Suppression des valeurs nulles et "trop grandes" (ici supérieur à la moyenne + écart-type)
k=1;
for i=1:50000,
	if 0 < data(i) & data(i) < m + sigma then
		data2(k)=data(i);
		k=k+1;
	end;
end; 
 
// Afficher les données épurées
histplot(100, data2)

disp("Affichage histogramme épuré");
pause;

// Déclaration des paramètres des lois
mu=0;
sigma=1;
k=2;
lambda=1;

// Définition des lois
function y=n(x),y=1/(sigma*sqrt(2*%pi))*exp(-1/2*((x-mu)/sigma)^2),endfunction; //loi normale
function y=logn(x),y=(1/(x*sigma*sqrt(2*%pi)))*exp(-((log(x)-mu)^2)/(2*sigma^2)),endfunction; //log-normale
function y=weib(x),y=((k/lambda)*(x/lambda)^(k-1))*exp(-(x/lambda)^k),endfunction; //loi de weibull

// Superposition des données avec la loi normale (paramètres estimés)
mu=mean(data2)
sigma=stdev(data2)
//histplot(100, data2)
fplot2d([0:10:4000], n, style=2)

disp("Superposition des données avec la loi normale");
pause;

// Superposition des données avec la loi log-normale (paramètres estimés)
mu=sum(log(data2))
mu=mu/length(data2)
sigma=0; for i=1:length(data2), sigma=sigma+(log(data2(i))-mu)^2;, end;
sigma=sigma/length(data2)
sigma=sqrt(sigma)
fplot2d([1:10:4000], logn, style=2)

disp("Superposition des données avec la loi log-normale");
pause;

// Superposition des données avec la loi de weibull (il n'y a pas de méthode directe pour estimer ces paramètres.
// Pour cette étape, on essaye plusieurs valeurs pour se rapprocher au mieux la forme de l'histogramme.
// Ex: Pour k, on commencer par 1 et on incrémente de 0.5 en 0.5, avec lambda à 1 au départ
// on stocke l'histogramme dans une variable
histo=zeros(1,max(data2))
for i=1:length(data2), histo(data2(i))=histo(data2(i))+1; ,end;

// On normalise l'affichage de la loi aux données
// avec k=2.5, et lambda=1, on a une correspondance "visuelle" intéressante.
k=2.5;
for i=1:10:length(histo), plot2d(i,weib(i/1000)/1000,-1);, end

disp("Superposition des données avec la loi de weibull");
pause;

// --- Calcul des résidus

//On normalise l'histogramme
histon=histo/(max(histo)*1000);
r=[,]

// A chaque position i du vecteur r, se trouvera la différence entre la valeur réelle de histon(i) et celle de la loi etudiée.
// on le fait pour chaque loi

// Pour la loi normale (en recalculant les estimateurs)
mu=mean(data2)
sigma=stdev(data2)
j=1; for i=1:length(histon), if histon(i)<>0 then r(j)=n(i)-histon(i); j=j+1; end; , end;
ss=sum(r)
//résultat: 0.0166543
disp("Résidus avec la loi normale: ");
disp(ss);

// Pour la loi log-normale (en recalculant les estimateurs)
mu=sum(log(data2))
mu=mu/length(data2)
sigma=0; for i=1:length(data2), sigma=sigma+(log(data2(i))-mu)^2;, end;
sigma=sigma/length(data2)
sigma=sqrt(sigma)
clear r
j=1; for i=1:length(histon), if histon(i)<>0 then r(j)=logn(i)-histon(i); j=j+1; end; , end;
ss=sum(r)
//résultat: 0.0219424 
disp("Résidus avec la loi log-normale: ");
disp(ss);

// Pour la loi de weibull (avec les paramètres k=2.5, lambda=1)
clear r
j=1; for i=1:length(histon), if histon(i)<>0 then r(j)=(weib(i/1000)/1000)-histon(i); j=j+1; end; , end;
ss=sum(r)
//résultat: 0.0289862
disp("Résidus avec la loi de weilbull: ");
disp(ss);

disp("Conclusion: la loi qui donne le moins de différence, donc le moins de différence avec les données est la loi normale.");
pause;
disp("Exercice 2 - Service Commercial");
disp("Fermer la fenêtre du graphique avant de continuer.");
pause;

//#### Service Commercial
// Regression linéaire

// Chargement des données dans une matrice
sp=read_csv('sp.csv',';');

// Convertir le string vers le double
sp=strtod(sp);

plot2d(sp, style=2)
disp("Affichage des données");
pause;

x=[1:241]
xbarre=mean(x)
ybarre=mean(sp)
for i=1:241,prodxy(i)=(x(i)-xbarre)*(sp(i)-ybarre);,end
for i=1:241,prodxx(i)=(x(i)-xbarre)^2;,end

// Calcule des paramètres a et b de la fonction
a=sum(prodxy)/sum(prodxx);
b=ybarre-a*xbarre
//résultat: a=18.133413 , b=2798.8477 

function y=f(x);y=a*x+b;endfunction

fplot2d([0:10:300],f,style=5)
disp("Droite affine obtenue par régression linéaire");
pause;

// Bonus: projection d'un scénario
sp2=sp;

est=zeros(1,300);
// On fait cinquante scénarios aléatoires sur les 58 prochaines semaines (
for j=1:50,
	for i=242:300,
		if rand(1,1)>0.5 then 
			sp2(i)=f(i)+(rand(1,1)*stdev(sp)*1.2-stdev(sp));
		else
			if sp2(i-1)<sp2(i-2) then
				sp2(i)=sp2(i-1)-rand()*100;
			else
				sp2(i)=sp2(i-1)+rand()*100;
			end;
		end;
		est(i)=est(i)+sp2(i);
	end;
end;

plot2d(sp2, style=5)
plot2d(sp, style=2)
disp("Projection scénario aléatoire");

est=est/50; // On calcule l'estimation moyenne de vente de portables totale
disp("En moyenne, on aurait ceci comme vente de portable par semaine, sur les prochaines semaines:");
disp(sum(est)/(300-242))
