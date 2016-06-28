// Chargement des données
agri=[100,60,76,74,90,93,102,98,103,110,117,118,112,115,116,121,134,130]
indu=[100,50,84,99,113,122,128,143,145,146,159,172,188,204,213,220,242,254]

disp("Le nuage et son centre de gravite");
for i=1:18,plot2d(agri(i),indu(i),-4),end;
xbarre=sum(agri)/18;
ybarre=sum(indu)/18;
plot2d(xbarre, ybarre, -2)
xtitle(['Le nuage et son centre de gravité'], 'agri', 'indu')
pause

disp("Regression linéaire");
for i=1:18,prodxy(i)=(agri(i)-xbarre)*(indu(i)-ybarre),end
for i=1:18,prodxx(i)=(agri(i)-xbarre)^2,end
for i=1:18,prodyy(i)=(indu(i)-ybarre)^2,end
achapeau=sum(prodxy)/sum(prodxx);
bchapeau=ybarre-achapeau*xbarre
function y=f(x);y=achapeau*x+bchapeau;endfunction
fplot2d(min(agri)-10:.1:max(agri)+10,f)
pause

disp("???");
a2chapeau=sum(prodxy)/sum(prodyy);
b2chapeau=xbarre-a2chapeau*ybarre
function y=g(x);y=(x-b2chapeau)/a2chapeau;endfunction
fplot2d(min(agri)-10:.1:max(agri)+10,g)
pause

for i=1:18,res(i)=indu(i)-f(agri(i)),end
xset("window", 2);
for i=1:18,plot2d(i,res(i),-1),end
function y=h(x);y=0;endfunction;
fplot2d(0:.1:19,h);
xtitle(['Residus'],'i','res')

xset("window",3);
r=[-45:10:45];
histplot(r, res);
xtitle(['Histogramme des residus'])
