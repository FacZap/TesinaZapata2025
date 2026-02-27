% INI
clc
area1_ini=34.71685026942442;
area2_ini=42.266246191143715;
area3_ini=22.769214035906693;
area4_ini=2.513764303269934;
area1=35.35580060269119; area2=44.26996515041091;
area3=23.697558590692203; area4=2.513764303269934;
for i=1:1:4
    eval(sprintf('area_ini%d=area%d;',i,i));
end
area_time=0;
bypass_time=50;
%fcu_time=20;
fcu_time=50;
% d_time=50;
uh112=0.014935258720777856; uh112_initial=uh112;
uh211=0.05299733469368127;  uh211_initial=uh211; 
uh222=0.08194236649754925;  uh222_initial=uh222;
uc112=0.0;                  uc112_initial=uc112;
uc211=0.0;                  uc211_initial=uc211;
uc222=0.0;                  uc222_initial=uc222;
fcu=0;
fcu_initial=0;
thin1=0;
fhin1=0;
thin2=0;
fhin2=0;
tcin1=0;
fcin1=0;
tcin2=0;
fcin2=0;
%
thin1_initial=0;
fhin1_initial=0;
thin2_initial=0;
fhin2_initial=0;
tcin1_initial=0;
fcin1_initial=0;
tcin2_initial=0;
fcin2_initial=0;
%
sp1=385;
sp2=400;
sp3=560;
sp4=340;
setpoints=[sp1 sp2 sp3 sp4];
load('sp_real','setpoints_real')
initials=[uh112_initial uh211_initial uh222_initial uc112_initial uc211_initial uc222_initial fcu_initial];
interval_time=10;
amp_time=10;
fail_constant=10;
% timeout=900;
d_time=50;
sim_time=300;
d_time_1=0;
d_time_2=0;
d_time_3=0;
t_sp_change=0;
caso=3;
RIC=1;
u1_in=0;	u1_end=0;
u2_in=0;	u2_end=0;
u3_in=0;	u3_end=0;
u4_in=0;	u4_end=0;
u5_in=0;	u5_end=0;
u6_in=0;	u6_end=0;
u7_in=0;	u7_end=0;
d1_in=0;	d1_end=0;
d2_in=0;	d2_end=0;
d3_in=0;	d3_end=0;
d4_in=0;	d4_end=0;
d5_in=0;	d5_end=0;
d6_in=0;	d6_end=0;
d7_in=0;	d7_end=0;
d8_in=0;	d8_end=0;
u1_in=initials(1);	u1_end=initials(1);
u2_in=initials(2);	u2_end=initials(2);
u3_in=initials(3);	u3_end=initials(3);


