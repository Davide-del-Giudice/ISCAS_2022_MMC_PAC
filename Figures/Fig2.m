function Fig2(prn)

close all
clc

% prn = 1;
% LCpower(prn)
% se prn=1 salva le figure power.eps

%% Local Variables
% Impostazione Figura
nx = 1;			% Numero di figure in orizzontale
ny = 2;			% Numero di figure in verticale
bx = 0.30;	    % Margini sinistro  e destro    [cm]
by = 0.25;		% Margini superiore e inferiore [cm]
fx = 7.30;		% Larghezza primo riquadro interno [cm]
fy = 1.7;		% Altezza riquadri interni   [cm]
dx = 0.0;		% Distanza orizzontale tra i riquadri [cm]
dy = 0.30;		% Distanza verticale tra i riquadri   [cm]
ox = 0.6;		% Offset orizzontale [cm]
oy = 0.06;		% Offset verticale   [cm]
ospl = 0.0;
fnt  = 8;		% Dimensione dei font per gli assi
fnl  = 8;		% Dimensione dei font per le labels
fnl2 = 7;		% Dimensione dei font per le labels

fwidth  = nx*fx+(nx-1)*dx+2*bx+ox
fheigth = ny*fy+(ny-1)*dy+2*by+ospl;

if fwidth > 8.5
    disp('Error. Plot wider than single column')
    return
end
%%
lincol5=[0 0 0];            % black
lincol3=0.75*[1 1 1];       % gray
lincol7=0.5*[1 1 1];        % gray
lincol8=0.25*[1 1 1];
linwid1=0.5;              % spessore 1
linwid2=1.5;              % spessore 2
red = [204 37 41]./255;

%% Creazione Figura
figure('Renderer', 'Painters',...
    'units','centimeters',...
    'position',[bx, by, fwidth, fheigth], ...
    'PaperUnits','centimeters', ...
    'PaperOrientation','portrait', ...
    'PaperPosition',[bx, by, fwidth, fheigth], ...
    'PaperType','A4', ...
    'Color','white' ...
    );
%%
% Creazione Riquadri e Grafici
% #format table ## [WaveView Analyzer] saved 16:33:34 Sun Mar 17 2019
% XVAL Ir Irdw Irup Is Isdw Isup It Itdw Itup Mcbn.Iarc Vr Vrdw Vrup Vs Vsdw Vsup Vt Vtdw Vtup neu Vndw Vnup
PAN_plus800  = load('PDc0@+800MW.mat');
PAN_minus800 = load('PDc0@-800MW.mat');
DEC = 1;

%%


for i=1:nx
    for j=1:ny
        h(i,j)=axes(...
            'units','centimeters',...
            'position',[bx+(i-1)*(fx+dx)+ox, by+(ny-j)*(fy+dy)+oy, fx fy],...
            'fontsize',fnt,...
            'fontname','helvetica',...
            'fontangle','normal',...
            'visible','on', ...
            'Color','none', ...
            'box','on', ...
            'XTickLabel', [], ...
            'YTickLabel', [], ...
            'XTick', [], ...
            'Ytick', []);
        
        OFF = 0;
        
        if j==1
            line(PAN_minus800.Fr, real(PAN_minus800.Idc), 'Color', lincol5, ...
                'LineWidth',  linwid1,...
                'Linestyle','-');
            
            hold on
            
            line(PAN_plus800.Fr, real(PAN_plus800.Idc), 'Color', red, ...
                'LineWidth',  linwid1,...
                'Linestyle','-');
            
%             line([0 350], [0 0], 'Color', lincol5, 'LineWidth',  linwid1, ...
%                 'Linestyle','--');
            
            
        elseif j==2
            line(PAN_minus800.Fr, imag(PAN_minus800.Idc), 'Color', lincol5, ...
                'LineWidth',  linwid1,...
                'Linestyle','-');
            
            hold on
            
            line(PAN_plus800.Fr, imag(PAN_plus800.Idc), 'Color', red, ...
                'LineWidth',  linwid1,...
                'Linestyle','-');
            
        end
        
        set(h(i,j),'Xgrid', 'on', 'Ygrid', 'on');
        
        set(h(i,j),...
            'units','centimeters',...
            'position',[bx+(i-1)*(fx+dx)+ox, by+(ny-j)*(fy+dy)+oy, fx fy],...
            'fontsize',fnt,...
            'fontname','helvetica',...
            'fontangle','normal',...
            'visible','on', ...
            'Color','none', ...
            'Xcolor',lincol7, ...
            'Ycolor',lincol7, ...
            'XTickMode', 'manual', ...
            'Xtick',[],...
            'YTickMode', 'manual', ...
            'Ytick',[], ...
            'box','on',...
            'Xscale','linear');
        
        if j==1
            format_ticks(h(i,j),{'$ $','$ $','$ $','$ $','$ $','$ $','$ $','$ $'},...
                {'$-0.05$','$0.05$','$0.15$','$0.25$','$0.35$'},...
                (0:50:350), linspace(-50e-3,350e-3,5),[],[],[0.020 0.020]);
            axlbl={'$$f [\mathrm{Hz}]$$','$$\mathrm{Re} \{ Y_{pp}^{0} \} [\mathrm{S}]$$'};
            
            lt=[0.01, 0.78];
            text(lt(1),lt(2),axlbl{2}, ...
                'fontname','times',...
                'fontangle','italic',...
                'fontsize',fnl, ...
                'fontweight', 'normal', ...
                'interpreter','latex',...
                'HorizontalAlignment','l',...
                'VerticalAlignment','bottom', ...
                'Unit', 'normalized' ...
                );
            
        elseif j==2
            format_ticks(h(i,j),{'$0$','$50$','$100$','$150$','$200$','$250$','$300$','$350$'},...
                {'$-0.10$','$0$','$0.10$','$0.20$','$0.30$'},...
                (0:50:350), linspace(-100e-3,300e-3,5),[],[],[0.020 0.020]);
            axlbl={'$$f [\mathrm{Hz}]$$','$$\mathrm{Im} \{ Y_{pp}^{0} \} [\mathrm{S}]$$'};
            
            lt=[1.00, 0.005];
            text(h(i,j),lt(1),lt(2),axlbl{1}, ...
                'fontname','times',...
                'fontangle','italic',...
                'fontsize',fnl, ...
                'fontweight', 'normal', ...
                'interpreter','latex',...
                'HorizontalAlignment','right',...
                'VerticalAlignment','bottom', ...
                'Color', 'black', ...
                'Unit', 'normalized' ...
                );
            
            lt=[0.01, 0.78];
            text(h(i,j),lt(1),lt(2),axlbl{2}, ...
                'fontname','times',...
                'fontangle','italic',...
                'fontsize',fnl, ...
                'fontweight', 'normal', ...
                'interpreter','latex',...
                'HorizontalAlignment','l',...
                'VerticalAlignment','bottom', ...
                'Unit', 'normalized' ...
                );
            
        end
        
    end
end



inset1 = axes(...
    'units','normalized',...
    'position',[0.6 0.75, 0.25 0.15],...
    'fontsize',fnt,...
    'fontname','helvetica',...
    'fontangle','normal',...
    'visible','on', ...
    'Color','none', ...
    'box','on', ...
    'XTickLabel', [], ...
    'YTickLabel', [], ...
    'XTick', [], ...
    'Ytick', [], ...
    'XLim', [0 25], ...
    'YLim', [-10e-3 10e-3]);

line(PAN_minus800.Fr, real(PAN_minus800.Idc), 'Color', lincol5, ...
    'LineWidth',  linwid1,...
    'Linestyle','-');

hold on

line(PAN_plus800.Fr, real(PAN_plus800.Idc), 'Color', red, ...
    'LineWidth',  linwid1,...
    'Linestyle','-');

set(inset1, 'Xgrid', 'on', 'Ygrid', 'on');

format_ticks(inset1,{'$0 $','$ $','$10$','$ $','$20$','$ $'},...
    {'$-0.01$','$0$','$0.01$'},...
    linspace(0,25,6), linspace(-10e-3,10e-3,3),[],[],[0.050 0.050]);
axlbl={'$ $','$ $'};


inset2 = axes(...
    'units','normalized',...
    'position',[0.6 0.28, 0.25 0.15],...
    'fontsize',fnt,...
    'fontname','helvetica',...
    'fontangle','normal',...
    'visible','on', ...
    'Color','none', ...
    'box','on', ...
    'XTickLabel', [], ...
    'YTickLabel', [], ...
    'XTick', [], ...
    'Ytick', [], ...
    'XLim', [0 25], ...
    'YLim', [0 50e-3]);

line(PAN_minus800.Fr, imag(PAN_minus800.Idc), 'Color', lincol5, ...
    'LineWidth',  linwid1,...
    'Linestyle','-');

hold on

line(PAN_plus800.Fr, imag(PAN_plus800.Idc), 'Color', red, ...
    'LineWidth',  linwid1,...
    'Linestyle','-');

set(inset2, 'Xgrid', 'on', 'Ygrid', 'on');


format_ticks(inset2,{'$0 $','$ $','$10$','$ $','$20$','$ $'},...
    {'$0$','$0.05$','$0.10$'},...
    linspace(0,25,6), linspace(0,100e-3,3),[],[],[0.050 0.050]);
axlbl={'$ $','$ $'};



if(prn)
    print -loose -painters -depsc2 ..\figs\PqDcY0.eps
end