function steer_cmd =  calc_autop(trajref, delta_x,...
    veh_pose, ref_pose, autop_params, index, veh_params,old_steer_cmd)
% 输出:
% steering_cmd      : 前轮偏角反馈控制量, rad
% acc               : 加速度补偿 m/s^2
% steer_feedforward ：前轮偏角，rad

% 输入:
% trajref           : 期望路径[X, Y, Theta, Radius]
% delta_x           : 期望位姿与车辆当前位姿的偏差[dx, dy, dtheta]
% veh_pose          : 车辆当前位姿[x, y, theta]
% autop_params      : autopilot MPC的参数
% index             : 滚动优化在trajref的初始index
% veh_params        : 车辆参数

% update parameters
NX = 4; % number of different state variable
NU = 1; % number of control variable
N = 20; % number of intervals in the horizon

% set up the weight matrix
Q=1*eye(N+1,N+1);   % x error rate
R=1*eye(N+1,N+1);   % y error rate
G=0.001*pi/180*eye(N+1,N+1);   % heading error rate
V=0.02*eye(N+1,N+1);   % delta error rate

%control variable
steer_cmd=zeros(NU,1);


lb=[-veh_params.max_steer_angle];
ub=[veh_params.max_steer_angle];
A=[];
b=[];
Aeq=[];
Beq=[];

options=optimset('Algorithm','active-set','Display', 'off');
[A,fval,exitflag]=fmincon(@(x)Autopilot_cost_function(...
    x,trajref(index:index+N+1,1:3), ...
    veh_pose, ref_pose, autop_params, index, veh_params,...
    N,R,Q,G,V,old_steer_cmd),[0],A,b,Aeq,Beq,lb,ub,[],options);

steer_cmd=A(1);

end
  
  
  
  
  
  
 
 
 