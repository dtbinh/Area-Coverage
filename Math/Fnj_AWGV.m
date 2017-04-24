function nj = Fnj_AWGV(Ri,Rj,ri,rj,t,xi,xj,yi,yj)
%FNJ_AWGV
%    NJ = FNJ_AWGV(RI,RJ,RI,RJ,T,XI,XJ,YI,YJ)

%    This function was generated by the Symbolic Math Toolbox version 7.1.
%    24-Apr-2017 12:05:03

t2 = Ri.*(1.0./2.0);
t3 = ri.*(1.0./2.0);
t4 = rj.*(1.0./2.0);
t15 = Rj.*(1.0./2.0);
t5 = t2+t3+t4-t15;
t6 = yi.*1i;
t7 = yj.*-1i;
t8 = t6+t7+xi-xj;
t9 = abs(t8);
t10 = 1.0./t9;
t11 = xi-xj;
t12 = abs(t11);
t13 = yi-yj;
t14 = abs(t13);
t16 = sinh(t);
t17 = t5.*t10.*t13.*t16;
t18 = cosh(t);
t19 = t12.^2;
t20 = t19.*(1.0./4.0);
t21 = t14.^2;
t22 = t21.*(1.0./4.0);
t23 = t5.^2;
t24 = t20+t22-t23;
t25 = sqrt(t24);
t26 = t10.*t11.*t18.*t25;
t27 = t17+t26;
t28 = abs(t27);
t31 = t5.*t10.*t11.*t16;
t32 = t10.*t13.*t18.*t25;
t33 = t31-t32;
t29 = abs(t33);
t30 = t28.^2;
t34 = t29.^2;
t35 = t30+t34;
t36 = 1.0./sqrt(t35);
t37 = conj(t25);
t38 = t5.*t10.*t13.*t18;
t40 = t10.*t11.*t16.*t37;
t41 = t38+t40;
t42 = t27.*t36.*t41;
t43 = t10.*t13.*t16.*t37;
t44 = t5.*t10.*t11.*t18;
t45 = t43-t44;
t46 = t33.*t36.*t45;
t47 = t42-t46;
t53 = t27.*t36.*t47;
t54 = t10.*t11.*t16.*t25;
t55 = t38-t53+t54;
t39 = abs(t55);
t49 = t33.*t36.*t47;
t50 = t10.*t13.*t16.*t25;
t51 = -t44+t49+t50;
t48 = abs(t51);
t52 = sign(t5);
t56 = t39.^2;
t57 = t48.^2;
t58 = t56+t57;
t59 = 1.0./sqrt(t58);
nj = [-t51.*t52.*t59;t52.*t55.*t59];
