function Ypp0Instb(prn)

clc
close all
% prn = 1;

%% Local Variables
% Impostazione Figura
nx = 1;			% Numero di figure in orizzontale
ny = 2;			% Numero di figure in verticale
bx = 0.18;	    % Margini sinistro  e destro    [cm]
by = 0.25;		% Margini superiore e inferiore [cm]
fx = 7.50;		% Larghezza primo riquadro interno [cm]
fy = 1.5;		% Altezza riquadri interni   [cm]
dx = 0.0;		% Distanza orizzontale tra i riquadri [cm]
dy = 0.20;		% Distanza verticale tra i riquadri   [cm]
ox = 0.6;		% Offset orizzontale [cm]
oy = 0.06;		% Offset verticale   [cm]
ospl = 0.0;
fnt  = 8;		% Dimensione dei font per gli assi
fnl  = 8;		% Dimensione dei font per le labels
fnl2 = 7;		% Dimensione dei font per le labels

fwidth  = nx*fx+(nx-1)*dx+2*bx+ox
fheigth = ny*fy+(ny-1)*dy+2*by+ospl

if fwidth > 8.5
    disp('Error. Plot wider than single column')
    return
end
%%
lincol5=[0 0 0];            % black
lincol3=0.75*[1 1 1];       % gray
lincol7=0.5*[1 1 1];        % gray
lincol8=0.25*[1 1 1];
red = [204 37 41]./255;

linwid1=0.5;              % spessore 1
linwid2=1.5;              % spessore 
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
load('dcInstability.mat');

DEC = 1;
time  = time(1:DEC:end);
VdcP  = VdcP(1:DEC:end);
L     = L(1:DEC:end);

IDX_L = find(L>=72.7e-3,1,'first')

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
            line(time, VdcP, 'Color', lincol5, ...
                'LineWidth',  linwid1,...
                'Linestyle','-');
            
            hold on
            
             line([time(IDX_L) time(IDX_L)], [185e3 215e3], 'Color', lincol7, ...
                'LineWidth',  linwid1,...
                'Linestyle','-.');
            
            xlim([0 40])
            ylim([185e3 215e3])
            
        elseif j==2
            
            line(time, L, 'Color', lincol5, ...
                'LineWidth',  linwid1,...
                'Linestyle','-');
            
            hold on
            
             line([0 time(IDX_L)], [L(IDX_L) L(IDX_L)], 'Color', lincol7, ...
                'LineWidth',  linwid1,...
                'Linestyle','-.');
                 
             line([time(IDX_L) time(IDX_L)], [L(IDX_L) 90e-3], 'Color', lincol7, ...
                'LineWidth',  linwid1,...
                'Linestyle','-.');
            
            xlim([0 40])
            ylim([48e-3 82e-3])
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
            format_ticks(h(i,j),{'$ $','$ $','$ $','$ $','$ $','$ $','$ $','$ $','$ $'},...
                {'$185$','$ $','$195$','$ $','$205$','$ $','$215$'},...
                (0:5:40), (185e3:5e3:215e3),[],[],[0.020 0.020]);
            axlbl={'$$t [\mathrm{s}]$$','$$V_{\mathrm{dc}} [\mathrm{kV}]$$'};
            
            
            lt=[0.02, 0.75];
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
            format_ticks(h(i,j),{'$0$','$ $','$10$','$ $','$20$','$ $','$30$','$ $','$40$'},...
                {'$50$','$ $','$60$','$ $','$70$','$ $','$80$'},...
                (0:5:40), (50e-3:5e-3:80e-3),[],[],[0.020 0.020]);
            axlbl={'$$t [\mathrm{s}]$$','$$L_{\mathrm{dc}} [\mathrm{mH}]$$'};
            
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
            
            lt=[0.02, 0.75];
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
    'position',[0.25 0.606, 0.25 0.08],...
    'fontsize',fnt*0.75,...
    'fontname','helvetica',...
    'fontangle','normal',...
    'visible','on', ...
    'Color','none', ...
    'box','on', ...
    'XTickLabel', [], ...
    'YTickLabel', [], ...
    'XTick', [], ...
    'Ytick', [], ...
    'XLim', [10 10.05]);

   line(time, VdcP, 'Color', lincol5, ...
                'LineWidth',  linwid1,...
                'Linestyle','-');
            


set(inset1, 'Xgrid', 'on', 'Ygrid', 'on');

format_ticks(inset1,{'$10$','$ $','$10.05$'},...
    {'$195$','$ $','$205$'},...
    linspace(10,10.05,3), linspace(195e3,205e3,3),[],[],[0.050 0.050]);
axlbl={'$ $','$ $'};



if(prn)
    print -loose -painters -depsc2 ..\figs\Ypp0Instb.eps
end