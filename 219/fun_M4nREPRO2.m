function QQloo=fun_M4nREPRO2(x, h,deff,nr_szer)% function QQloo=fun_loo(x,liczba_punktow,dlugosc_uczenia)
%function QQloo=fun_M4n(x, h,deff=3)% function QQloo=fun_loo(x,liczba_punktow,dlugosc_uczenia)
%function QQloo=fun_M4yearly()% function QQloo=fun_loo(x,liczba_punktow,dlugosc_uczenia)
%function QQloo=fun_M4quarterly(x, dl_horyzontu)% function QQloo=fun_loo(x,liczba_punktow,dlugosc_uczenia)

wagi=1;


    x(isnan(x)==1)=[];
x=[x nan];
x_wejscie=x;




liczba_punktow=1;
dlugosc_uczenia=length(x)-liczba_punktow;
dl_horyzontu=12;



pocz=12;%3
kon=12;%24
dl_horyzontu=h;



l_sasadow=38;%dlajefr38, dla rozm 50
rozne_definicje=0;
definicja=3;
definicja=deff;


% wagi=5;%0 - mean (surowe dane), 1 - z wagami, 2 rozmyte
if wagi==0
    l_sasadow=50;
elseif wagi==1  
    l_sasadow=50;
    l_sasadow=10;
end

if length(x)<20%bo przy krotszych szeregach byl problem
    pocz=3;%3
kon=3;%24
l_sasadow=7;
if nr_szer>=77001&&nr_szer<77001+1248
    l_sasadow=10;
end

end

if (wagi==0 || wagi==1)
if (l_sasadow>=dlugosc_uczenia-kon-1)
l_sasadow=dlugosc_uczenia-kon-2;
end
end
par_p=1;%parametr p do roznicowania wag(wart:1||0.25)
par_alfa=2;%parametr alpha do roznicowania wag(wart:0||-0.8||5)




szereg=x;

szereg=szereg(end-liczba_punktow-dlugosc_uczenia+1:end);
lw=liczba_punktow+dlugosc_uczenia;
lu=lw-liczba_punktow;
lt=lw-lu; %%d�ugo�c fragmentu testowego (liczba wyraz�w testowych)
% lt=1000;
%rozne_definicje=0;
if(rozne_definicje==1)
    DD=1:6;%DD=1:6
else
    %DD=norm+1;
    DD=definicja+1;
end


    dd=DD;
    %     tt=12;%zmienna do def obr 2.3 (5 u mnie)
    norm=dd-1;
    do=pocz; %d�ugo�� obrazu wej�ciowego
    hp=dl_horyzontu; %horyzont prognozy - prognozujemu jednocze�nie od 1 do hp wyraz�w
%     LS=2:l_sasadow; %liczba najbli�szych s�siad�w obrazu wej�ciowego, z kt�rych oblicza si� prognoz�
    
    if wagi==1
        LS=2:l_sasadow; %liczba najbli�szych s�siad�w obrazu wej�ciowego, z kt�rych oblicza si� prognoz�
 LS=l_sasadow:l_sasadow;
    end
    
    szereg1=[szereg zeros(1,hp)+NaN]; % przed�u�enie szeregu NaNami (dodanie hp wyraz�w NaN)
    %Bs=zeros(max(do),hp)+NaN; %macierz do przechowywania wynik�w
    
%     for ls=LS %po liczbie najbli�szych sasiad�w
%         ls
        
        i=do; %po d�ugo�ci obrazu
                   %  i
            %przygotowanie macierzy z obrazami wej�ciowymi i wyj�ciowymi
            %             Bkmape=zeros(lt,hp);
            % B12(ls,dd)=struct('Bs12',nan(i,hp));
            x=zeros(lw - i,i);
            y=zeros(lw - i,hp);
            Y=zeros(lw - i,hp);
            xs=[];
            yp=[];
            Yt=[];
            Yp=[];
            X=x;
            for l=1:(lw - i) %tworzymy obrazy
                %obrazy wej�ciowe
                q=szereg(l:(l+i-1)); %pobranie fragmentu do l-tego obrazu wej�ciowego
                if norm==3
                    xs(l) = mean(q); %warto�� �rednia fragmentu
                    xd(l) = (sum((q-xs(l)).^2))^0.5; %dyspersja - mianownik wzoru
                    x(l,:) = (q - xs(l)) / xd(l); %normalizacja obrazu wej�ciowego
                
                end
                %             x(l,:) = (q - xs(l)) / xd(l); %normalizacja obrazu wej�ciowego
                
                if norm==1
                    xs(l) = mean(q);
                    x(l,:) = q/xs(l);
                end
               
                
                
                X(l,:) = q; %fragmenty szeregu bez normalizacji
                %obrazy wyj�ciowe
                q=szereg1((l+i):(l+i+hp-1)); %pobranie fragmentu do l-tego obrazu wyj�ciowego
                if(norm==0||norm==3)
                    y(l,:) = (q - xs(l)) / xd(l); %normalizacja obrazu wyj�ciowego
                    
                elseif(norm==1)
                    y(l,:) = (q / xs(l));
                    %                 elseif(norm==2)
                
                end
                
                Y(l,:) = q; %fragmenty szeregu bez normalizacji
            end
            %             x(isnan(x))=[];
            %             x=x(isfinite(x(:, 1)), :);
            Yt=Y((lu - i +1):end,:); %cz�� testowa Y
            Yu=Y(1:(lu - i),:); %cz�� ucz�ca Y
            
            %odleg�o�ci pomiedzy obrazami wej�ciowymi (ka�dy z ka�dym)
            d=dist(x');
            
         
           
            ls=LS; %po liczbie najbli�szych sasiad�w
                
            
            
            
            Yp=[];
            j=1;
                jj=j+lu-i; %numer obrazu testowego liczony od poczatku zbioru danych
                
                dj=d(jj,1:jj-1); %odleg�o�ci od j-tego obrazu testowego do obraz�w ucz�cych, czyli
                %obraz�w o numerach od 1 do jj-1
                [dj,nr]=sort(dj); %sortujemy odl. od najmniejszej do najwi�kszej, nr to numery obraz�w przed sortowaniem
                yp=y(nr(1:end),:); %pobieramy obrazy wyj�ciowe najbli�szych ls s�siad�w
                %                 yp=mean(yp,1); %u�redniamy te obrazy - to jest nasz prognozowany obraz
                
                %dj=dj(isfinite(dj));
                
                   if wagi==1
                    yp=y(nr(1:ls),:); %pobieramy obrazy wyj�ciowe najbli�szych ls s�siad�w
                    %                 yp=mean(yp,1); %wawagujemy te obrazy - to jest nasz prognozowany obraz
                    pcz=1;
                    %                 dj(isnan(dj))=[];
                    %                 dj=dj(isfinite(dj(:, 1)), :);
                    Blad(dd).ass(ls,i).dj=dj;
                    %                 Blad2(dd,i).dj.dj(ls,:)=dj;
                    gora=[];paf=[];WA=[];WA2=[];
                    for el=1:ls
                        %                 paf=dj(pcz)/dj(el);
                        paf=dj(el)/dj(ls);
                        if dj(ls)==0
                            dj(ls)=1;
                        end
                        paf=dj(el)/dj(ls);
                        WA(el)=((1-paf)/(1+2*paf)-1)+1;
                        WA2(el)=1-paf;%prostszy sposob zapisu dla p=1 i alpha=0
                        gora(el,:)=yp(el,:)*WA(el);
                        
                        Blad(dd).ass(ls,i).paf(el)=paf;
                        Blad(dd).ass(ls,i).WA(el)=WA(el);
                        %                 Blad(dd).ass(ls,i).WA2(el)=WA2(el);
                        Blad(dd).ass(ls,i).gora(el,:)=gora(el,:);
                    end
                    %                 gorasum=sum(gora);
                    yp=sum(gora)/sum(WA);
                    yp=nansum(gora)/nansum(WA);
                    %                  yp=sum(gora)./sum(WA);
               
                   end
                
                if(norm==0||norm==3)
                    Yp(j,:)=yp*xd(jj)+xs(jj); %obliczenie prognozy szeregu czasowego - dekodowanie
                elseif norm==1
                    Yp(j,:)=yp*xs(jj);
                    %                 elseif norm==2
                
                end
                %             Yp(j,:)=yp*xd(jj)+xs(jj); %obliczenie prognozy szeregu czasowego - dekodowanie
                
            
            
            Ptdr(ls,i).xpp=Yp;%prognoza
            
    
   
    
   
        QQloo(1).Yp(dd,:)=Ptdr(ls,do);

    
    QQloox(1).Yp(dd,:)=Ptdr(ls,do);
    %     plot(QQloo(1).q1m')

%assignin('base', 'QQloo', QQloo)%eksport zmiennej z funkcji do workspace
assignin('base', 'QQloox', QQloox)%eksport zmiennej z funkcji do workspace
assignin('base', 'dd', dd)%eksport zmiennej z funkcji do workspace

end