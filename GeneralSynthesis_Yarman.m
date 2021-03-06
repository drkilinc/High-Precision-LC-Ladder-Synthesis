function [k,q,Highpass_Elements,Lowpass_Elements]=GeneralSynthesis_Yarman(a,b)
% This is a general sythesis program developed by yarman for given Minimum
% Function F(p)=a(p)/b(p)
na=length(a);nb=length(b);eps_zero=1e-8;na1=na-1;
if(na-nb)==0;n=nb;end
if abs(na-nb)>0
    comment='nb is different than na. Your Function F(p)=a(p)/b(p)is not proper for our synthesis package'
end
aa=a;bb=b;
[a,b,ndc]=Check_immitance(aa,bb);
n1=n-1;

%--------------------------------------------------------------------------
if ndc==0
    Comment='ndc=0, Lowpass Ladder '
    q=LowpassLadder_Yarman(a,b);
    k=0;Comment=('No transmission zero at DC. Therefore, we set k=0')
end
    for i=1:ndc
            [kr,R,ar]=Highpass_Remainder(a,b);
                        k(i)=abs(kr);
%-----Fr(p)=a(p)/b(p)
            clear a;clear b
            a=abs(R);b=abs(ar);
%--------------------------------------------------------------------------
%'Corrections on the Ladder Coefficients'
if i<ndc;[a,b]=Laddercorrection_onF(eps_zero,a,b);end
%--------------------------------------------------------------------------  
if (ndc-1)>0;R(ndc-1)=0.0;end
    end
 % -----Patch made on April 4, 2011
 if (n-ndc)>0
   if abs(a(1))<1e-8
       % Design='Lowpass Design with a(1)=0: k(ndc)/p+{a(p)/b(p)}=k(ndc)/p+1/{q(1)p+..'
        q=LowpassLadder_Yarman(a,b);
   end
   if abs(b(1))<1e-8
      %Design='Lowpass Design with b(1)=0: k(ndc)/p+{a(p)/b(p)}=k(ndc)/p+q(1)p+..'
      q=LowpassLadder_Yarman(b,a);
   end
 end
 % end of Patch made on April 4, 2011
%
 if (n1-ndc)==0;q=0;%'Synthesis with n=ndc',Constant_Termination=a(1)/b(1),
 end
 if ndc>0
 Highpass_Elements=1./k;
 end
 if ndc==0
     Highpass_Elements='There is no highpass elment'
 end
 Lowpass_Elements=q;
 if q==0,q=0; %'highpass design; there is no lowpass component'
 end
 if na1==ndc; Highpass_Elements(ndc+1)=a(1)/b(1);end
end
