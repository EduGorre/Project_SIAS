%{
    DESCRIPTION:
    This function calculates the normalized position of each spar for the 
    first section based on the spar position of the other two sections. 

    INPUTS:
    - eta: vector of 3 dimensions with the normalized position of the spars 
           from sections 2 and 3 [front, middle, rear]
    - chord: vector of 3 dimensions with the chord of each section 
    - y_pos: vector of 3 dimensions with the y-coordinate of each section
    - x1, x2, x3: vectors of 2 dimensions with the LE and TE coordinates of
                  each section
    - Span: interger = b
    - x_LE, x_TE: functions of y that define the LE and TE 

    OUTPUTS:
    - eta_sec1: vector of 3 dimensions with the normalized position of the 
                spars from section 1 [front, middle, rear]
    - Plot of the definition of the wing box
%}

function [eta_sec1]=wing_box_def(eta,chord,y_pos,x1,x2,x3,span,x_LE,x_TE)
    x_front=@(y) (x3(1)+eta(1)*chord(3)-x2(1)-eta(1)*chord(2))/(y_pos(3)-y_pos(2))*(y-y_pos(2))+x2(1)+eta(1)*chord(2);
    x_mid=@(y) (x3(1)+eta(2)*chord(3)-x2(1)-eta(2)*chord(2))/(y_pos(3)-y_pos(2))*(y-y_pos(2))+x2(1)+eta(2)*chord(2);
    x_rear=@(y) (x3(1)+eta(3)*chord(3)-x2(1)-eta(3)*chord(2))/(y_pos(3)-y_pos(2))*(y-y_pos(2))+x2(1)+eta(3)*chord(2);
    
    eta_sec1(1)=x_front(y_pos(1));
    eta_sec1(2)=x_front(y_pos(2));
    eta_sec1(3)=x_front(y_pos(3));
    
    y_vec=linspace(0,span/2,100);
    figure()
    plot(x_LE(y_vec),y_vec,'b')
    hold on
    plot(x_TE(y_vec),y_vec,'b')
    hold on
    plot(x_front(y_vec),y_vec,'k')
    hold on
    plot(x_mid(y_vec),y_vec,'k')
    hold on
    plot(x_rear(y_vec),y_vec,'k')
    hold on
    plot(x1,y_pos(1)*[1 1],'r')
    hold on
    plot(x2,y_pos(2)*[1 1],'r')
    hold on
    plot(x3,y_pos(3)*[1 1],'r')
    str=sprintf('Top view of the wing: $\\eta_{FS}$=%.2f, $\\eta_{MS}$=%.2f, $\\eta_{RS}$=%.2f',eta(1),eta(2),eta(3));
    title(str,'Interpreter','latex')
    xlabel('x','Interpreter','latex')
    ylabel('y','Interpreter','latex')
    set(gca,'TickLabelInterpreter','latex');
    axis equal
end