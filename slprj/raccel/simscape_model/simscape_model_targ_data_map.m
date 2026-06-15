    function targMap = targDataMap(),

    ;%***********************
    ;% Create Parameter Map *
    ;%***********************
    
        nTotData      = 0; %add to this count as we go
        nTotSects     = 5;
        sectIdxOffset = 0;

        ;%
        ;% Define dummy sections & preallocate arrays
        ;%
        dumSection.nData = -1;
        dumSection.data  = [];

        dumData.logicalSrcIdx = -1;
        dumData.dtTransOffset = -1;

        ;%
        ;% Init/prealloc paramMap
        ;%
        paramMap.nSections           = nTotSects;
        paramMap.sectIdxOffset       = sectIdxOffset;
            paramMap.sections(nTotSects) = dumSection; %prealloc
        paramMap.nTotData            = -1;

        ;%
        ;% Auto data (rtP)
        ;%
            section.nData     = 1;
            section.data(1)  = dumData; %prealloc

                    ;% rtP.FrmWksBus_2277297056879121903_TU
                    section.data(1).logicalSrcIdx = 0;
                    section.data(1).dtTransOffset = 0;

            nTotData = nTotData + section.nData;
            paramMap.sections(1) = section;
            clear section

            section.nData     = 3;
            section.data(3)  = dumData; %prealloc

                    ;% rtP.VSrc_eq_amp
                    section.data(1).logicalSrcIdx = 1;
                    section.data(1).dtTransOffset = 0;

                    ;% rtP.w
                    section.data(2).logicalSrcIdx = 2;
                    section.data(2).dtTransOffset = 1;

                    ;% rtP.ChangeDetector_ChangeType
                    section.data(3).logicalSrcIdx = 3;
                    section.data(3).dtTransOffset = 2;

            nTotData = nTotData + section.nData;
            paramMap.sections(2) = section;
            clear section

            section.nData     = 1;
            section.data(1)  = dumData; %prealloc

                    ;% rtP.MonostableFlipFlop_x0
                    section.data(1).logicalSrcIdx = 4;
                    section.data(1).dtTransOffset = 0;

            nTotData = nTotData + section.nData;
            paramMap.sections(3) = section;
            clear section

            section.nData     = 7;
            section.data(7)  = dumData; %prealloc

                    ;% rtP.Constant_Value
                    section.data(1).logicalSrcIdx = 5;
                    section.data(1).dtTransOffset = 0;

                    ;% rtP.SineWave_Bias
                    section.data(2).logicalSrcIdx = 6;
                    section.data(2).dtTransOffset = 1;

                    ;% rtP.SineWave_Phase
                    section.data(3).logicalSrcIdx = 7;
                    section.data(3).dtTransOffset = 2;

                    ;% rtP.Constant_Value_ezxolk4shd
                    section.data(4).logicalSrcIdx = 8;
                    section.data(4).dtTransOffset = 3;

                    ;% rtP.UnitDelay_InitialCondition
                    section.data(5).logicalSrcIdx = 9;
                    section.data(5).dtTransOffset = 4;

                    ;% rtP.Constant1_Value
                    section.data(6).logicalSrcIdx = 10;
                    section.data(6).dtTransOffset = 5;

                    ;% rtP.HitCrossing_Offset
                    section.data(7).logicalSrcIdx = 11;
                    section.data(7).dtTransOffset = 6;

            nTotData = nTotData + section.nData;
            paramMap.sections(4) = section;
            clear section

            section.nData     = 2;
            section.data(2)  = dumData; %prealloc

                    ;% rtP.UnitDelay1_InitialCondition
                    section.data(1).logicalSrcIdx = 12;
                    section.data(1).dtTransOffset = 0;

                    ;% rtP.UnitDelay_InitialCondition_ds2jg10wsv
                    section.data(2).logicalSrcIdx = 13;
                    section.data(2).dtTransOffset = 1;

            nTotData = nTotData + section.nData;
            paramMap.sections(5) = section;
            clear section


            ;%
            ;% Non-auto Data (parameter)
            ;%


        ;%
        ;% Add final counts to struct.
        ;%
        paramMap.nTotData = nTotData;



    ;%**************************
    ;% Create Block Output Map *
    ;%**************************
    
        nTotData      = 0; %add to this count as we go
        nTotSects     = 2;
        sectIdxOffset = 0;

        ;%
        ;% Define dummy sections & preallocate arrays
        ;%
        dumSection.nData = -1;
        dumSection.data  = [];

        dumData.logicalSrcIdx = -1;
        dumData.dtTransOffset = -1;

        ;%
        ;% Init/prealloc sigMap
        ;%
        sigMap.nSections           = nTotSects;
        sigMap.sectIdxOffset       = sectIdxOffset;
            sigMap.sections(nTotSects) = dumSection; %prealloc
        sigMap.nTotData            = -1;

        ;%
        ;% Auto data (rtB)
        ;%
            section.nData     = 9;
            section.data(9)  = dumData; %prealloc

                    ;% rtB.oubxqspwod
                    section.data(1).logicalSrcIdx = 0;
                    section.data(1).dtTransOffset = 0;

                    ;% rtB.jukrnxvliq
                    section.data(2).logicalSrcIdx = 1;
                    section.data(2).dtTransOffset = 1;

                    ;% rtB.dc4ls1uyzy
                    section.data(3).logicalSrcIdx = 2;
                    section.data(3).dtTransOffset = 2;

                    ;% rtB.iqwtgpffb2
                    section.data(4).logicalSrcIdx = 3;
                    section.data(4).dtTransOffset = 6;

                    ;% rtB.fo14nkxzwy
                    section.data(5).logicalSrcIdx = 4;
                    section.data(5).dtTransOffset = 10;

                    ;% rtB.cgh5hktsjq
                    section.data(6).logicalSrcIdx = 5;
                    section.data(6).dtTransOffset = 11;

                    ;% rtB.bywbs50iot
                    section.data(7).logicalSrcIdx = 6;
                    section.data(7).dtTransOffset = 12;

                    ;% rtB.jbpkcbmsoh
                    section.data(8).logicalSrcIdx = 7;
                    section.data(8).dtTransOffset = 16;

                    ;% rtB.ihxl5wrkqd
                    section.data(9).logicalSrcIdx = 8;
                    section.data(9).dtTransOffset = 44;

            nTotData = nTotData + section.nData;
            sigMap.sections(1) = section;
            clear section

            section.nData     = 3;
            section.data(3)  = dumData; %prealloc

                    ;% rtB.eg2onjjxzy
                    section.data(1).logicalSrcIdx = 9;
                    section.data(1).dtTransOffset = 0;

                    ;% rtB.oehfmw05sg
                    section.data(2).logicalSrcIdx = 10;
                    section.data(2).dtTransOffset = 1;

                    ;% rtB.piz1w4neql
                    section.data(3).logicalSrcIdx = 11;
                    section.data(3).dtTransOffset = 2;

            nTotData = nTotData + section.nData;
            sigMap.sections(2) = section;
            clear section


            ;%
            ;% Non-auto Data (signal)
            ;%


        ;%
        ;% Add final counts to struct.
        ;%
        sigMap.nTotData = nTotData;



    ;%*******************
    ;% Create DWork Map *
    ;%*******************
    
        nTotData      = 0; %add to this count as we go
        nTotSects     = 7;
        sectIdxOffset = 2;

        ;%
        ;% Define dummy sections & preallocate arrays
        ;%
        dumSection.nData = -1;
        dumSection.data  = [];

        dumData.logicalSrcIdx = -1;
        dumData.dtTransOffset = -1;

        ;%
        ;% Init/prealloc dworkMap
        ;%
        dworkMap.nSections           = nTotSects;
        dworkMap.sectIdxOffset       = sectIdxOffset;
            dworkMap.sections(nTotSects) = dumSection; %prealloc
        dworkMap.nTotData            = -1;

        ;%
        ;% Auto data (rtDW)
        ;%
            section.nData     = 27;
            section.data(27)  = dumData; %prealloc

                    ;% rtDW.ns3sryrqck
                    section.data(1).logicalSrcIdx = 0;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.b3smama2eu
                    section.data(2).logicalSrcIdx = 1;
                    section.data(2).dtTransOffset = 2;

                    ;% rtDW.pl5rsz41nv
                    section.data(3).logicalSrcIdx = 2;
                    section.data(3).dtTransOffset = 4;

                    ;% rtDW.lcbzakxitd
                    section.data(4).logicalSrcIdx = 3;
                    section.data(4).dtTransOffset = 5;

                    ;% rtDW.gr1tl3jpbw
                    section.data(5).logicalSrcIdx = 4;
                    section.data(5).dtTransOffset = 7;

                    ;% rtDW.fpvjvn3i0x
                    section.data(6).logicalSrcIdx = 5;
                    section.data(6).dtTransOffset = 8;

                    ;% rtDW.jn1vj0hjog
                    section.data(7).logicalSrcIdx = 6;
                    section.data(7).dtTransOffset = 9;

                    ;% rtDW.mscthsnh4c
                    section.data(8).logicalSrcIdx = 7;
                    section.data(8).dtTransOffset = 10;

                    ;% rtDW.kwvh1h53fr
                    section.data(9).logicalSrcIdx = 8;
                    section.data(9).dtTransOffset = 11;

                    ;% rtDW.pxztrufhtr
                    section.data(10).logicalSrcIdx = 9;
                    section.data(10).dtTransOffset = 12;

                    ;% rtDW.ieoipkasg0
                    section.data(11).logicalSrcIdx = 10;
                    section.data(11).dtTransOffset = 13;

                    ;% rtDW.kgcp153raj
                    section.data(12).logicalSrcIdx = 11;
                    section.data(12).dtTransOffset = 14;

                    ;% rtDW.fyndzzco0o
                    section.data(13).logicalSrcIdx = 12;
                    section.data(13).dtTransOffset = 15;

                    ;% rtDW.ocr2fb2htt
                    section.data(14).logicalSrcIdx = 13;
                    section.data(14).dtTransOffset = 16;

                    ;% rtDW.potn2143xj
                    section.data(15).logicalSrcIdx = 14;
                    section.data(15).dtTransOffset = 17;

                    ;% rtDW.nqlucgamt1
                    section.data(16).logicalSrcIdx = 15;
                    section.data(16).dtTransOffset = 18;

                    ;% rtDW.e3kmgxq2mg
                    section.data(17).logicalSrcIdx = 16;
                    section.data(17).dtTransOffset = 19;

                    ;% rtDW.ijslwcksyt
                    section.data(18).logicalSrcIdx = 17;
                    section.data(18).dtTransOffset = 20;

                    ;% rtDW.c3bez4tbj3
                    section.data(19).logicalSrcIdx = 18;
                    section.data(19).dtTransOffset = 21;

                    ;% rtDW.pyb1kyt3pn
                    section.data(20).logicalSrcIdx = 19;
                    section.data(20).dtTransOffset = 22;

                    ;% rtDW.a5ye3yw0eg
                    section.data(21).logicalSrcIdx = 20;
                    section.data(21).dtTransOffset = 23;

                    ;% rtDW.kypwc3cmls
                    section.data(22).logicalSrcIdx = 21;
                    section.data(22).dtTransOffset = 24;

                    ;% rtDW.hej2ckjb2i
                    section.data(23).logicalSrcIdx = 22;
                    section.data(23).dtTransOffset = 41;

                    ;% rtDW.pfr4ur4ccw
                    section.data(24).logicalSrcIdx = 23;
                    section.data(24).dtTransOffset = 42;

                    ;% rtDW.cqmxv4ikm2
                    section.data(25).logicalSrcIdx = 24;
                    section.data(25).dtTransOffset = 49;

                    ;% rtDW.kmek413xjz
                    section.data(26).logicalSrcIdx = 25;
                    section.data(26).dtTransOffset = 50;

                    ;% rtDW.ccuuuzbrna
                    section.data(27).logicalSrcIdx = 26;
                    section.data(27).dtTransOffset = 51;

            nTotData = nTotData + section.nData;
            dworkMap.sections(1) = section;
            clear section

            section.nData     = 25;
            section.data(25)  = dumData; %prealloc

                    ;% rtDW.gtoj3t1yxd.TimePtr
                    section.data(1).logicalSrcIdx = 27;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.oyiubqed5q
                    section.data(2).logicalSrcIdx = 28;
                    section.data(2).dtTransOffset = 1;

                    ;% rtDW.mbloowwnzy
                    section.data(3).logicalSrcIdx = 29;
                    section.data(3).dtTransOffset = 2;

                    ;% rtDW.mpsvq1mqtc
                    section.data(4).logicalSrcIdx = 30;
                    section.data(4).dtTransOffset = 3;

                    ;% rtDW.br1m5dmrms
                    section.data(5).logicalSrcIdx = 31;
                    section.data(5).dtTransOffset = 4;

                    ;% rtDW.g524oiacv1
                    section.data(6).logicalSrcIdx = 32;
                    section.data(6).dtTransOffset = 5;

                    ;% rtDW.phlhmluwcg
                    section.data(7).logicalSrcIdx = 33;
                    section.data(7).dtTransOffset = 6;

                    ;% rtDW.knwdpc1g4s
                    section.data(8).logicalSrcIdx = 34;
                    section.data(8).dtTransOffset = 7;

                    ;% rtDW.noo2ygukqs
                    section.data(9).logicalSrcIdx = 35;
                    section.data(9).dtTransOffset = 8;

                    ;% rtDW.jr35zxfzee
                    section.data(10).logicalSrcIdx = 36;
                    section.data(10).dtTransOffset = 9;

                    ;% rtDW.pza0u3qsa1
                    section.data(11).logicalSrcIdx = 37;
                    section.data(11).dtTransOffset = 10;

                    ;% rtDW.cdyju4m2i0.AQHandles
                    section.data(12).logicalSrcIdx = 38;
                    section.data(12).dtTransOffset = 11;

                    ;% rtDW.pdlawnzz43.AQHandles
                    section.data(13).logicalSrcIdx = 39;
                    section.data(13).dtTransOffset = 12;

                    ;% rtDW.jtc0bcbtj5.AQHandles
                    section.data(14).logicalSrcIdx = 40;
                    section.data(14).dtTransOffset = 13;

                    ;% rtDW.b1qfia0exu
                    section.data(15).logicalSrcIdx = 41;
                    section.data(15).dtTransOffset = 14;

                    ;% rtDW.inxwtzgorm
                    section.data(16).logicalSrcIdx = 42;
                    section.data(16).dtTransOffset = 15;

                    ;% rtDW.hh0oyp1f2n
                    section.data(17).logicalSrcIdx = 43;
                    section.data(17).dtTransOffset = 16;

                    ;% rtDW.jlzxsfp4ps
                    section.data(18).logicalSrcIdx = 44;
                    section.data(18).dtTransOffset = 17;

                    ;% rtDW.euqu5245ne
                    section.data(19).logicalSrcIdx = 45;
                    section.data(19).dtTransOffset = 18;

                    ;% rtDW.jm4otpptor.AQHandles
                    section.data(20).logicalSrcIdx = 46;
                    section.data(20).dtTransOffset = 19;

                    ;% rtDW.jqfng4wcbc.AQHandles
                    section.data(21).logicalSrcIdx = 47;
                    section.data(21).dtTransOffset = 20;

                    ;% rtDW.pdlawnzz43n.AQHandles
                    section.data(22).logicalSrcIdx = 48;
                    section.data(22).dtTransOffset = 21;

                    ;% rtDW.jtc0bcbtj5y.AQHandles
                    section.data(23).logicalSrcIdx = 49;
                    section.data(23).dtTransOffset = 22;

                    ;% rtDW.cdyju4m2i0e.AQHandles
                    section.data(24).logicalSrcIdx = 50;
                    section.data(24).dtTransOffset = 23;

                    ;% rtDW.fio5gfihvq.AQHandles
                    section.data(25).logicalSrcIdx = 51;
                    section.data(25).dtTransOffset = 24;

            nTotData = nTotData + section.nData;
            dworkMap.sections(2) = section;
            clear section

            section.nData     = 9;
            section.data(9)  = dumData; %prealloc

                    ;% rtDW.lweclmmpe0
                    section.data(1).logicalSrcIdx = 52;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.ddp1obzjvo
                    section.data(2).logicalSrcIdx = 53;
                    section.data(2).dtTransOffset = 1;

                    ;% rtDW.ceom2bmae1
                    section.data(3).logicalSrcIdx = 54;
                    section.data(3).dtTransOffset = 2;

                    ;% rtDW.lbsdpz4ihp
                    section.data(4).logicalSrcIdx = 55;
                    section.data(4).dtTransOffset = 3;

                    ;% rtDW.bdn1ymfo5h
                    section.data(5).logicalSrcIdx = 56;
                    section.data(5).dtTransOffset = 4;

                    ;% rtDW.ddp1obzjvog
                    section.data(6).logicalSrcIdx = 57;
                    section.data(6).dtTransOffset = 5;

                    ;% rtDW.ceom2bmae1z
                    section.data(7).logicalSrcIdx = 58;
                    section.data(7).dtTransOffset = 6;

                    ;% rtDW.lweclmmpe0z
                    section.data(8).logicalSrcIdx = 59;
                    section.data(8).dtTransOffset = 7;

                    ;% rtDW.alx0pc0wvg
                    section.data(9).logicalSrcIdx = 60;
                    section.data(9).dtTransOffset = 8;

            nTotData = nTotData + section.nData;
            dworkMap.sections(3) = section;
            clear section

            section.nData     = 6;
            section.data(6)  = dumData; %prealloc

                    ;% rtDW.n0zxacxf1l.PrevIndex
                    section.data(1).logicalSrcIdx = 61;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.n5zb5g2pxc
                    section.data(2).logicalSrcIdx = 62;
                    section.data(2).dtTransOffset = 1;

                    ;% rtDW.hu1sw1yly1
                    section.data(3).logicalSrcIdx = 63;
                    section.data(3).dtTransOffset = 7;

                    ;% rtDW.oohsc251vh
                    section.data(4).logicalSrcIdx = 64;
                    section.data(4).dtTransOffset = 8;

                    ;% rtDW.eizatzn21x
                    section.data(5).logicalSrcIdx = 65;
                    section.data(5).dtTransOffset = 9;

                    ;% rtDW.ekt2heefmx
                    section.data(6).logicalSrcIdx = 66;
                    section.data(6).dtTransOffset = 10;

            nTotData = nTotData + section.nData;
            dworkMap.sections(4) = section;
            clear section

            section.nData     = 5;
            section.data(5)  = dumData; %prealloc

                    ;% rtDW.gzroy3y1us
                    section.data(1).logicalSrcIdx = 67;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.n3josujmv0
                    section.data(2).logicalSrcIdx = 68;
                    section.data(2).dtTransOffset = 1;

                    ;% rtDW.g4yjw3ibic
                    section.data(3).logicalSrcIdx = 69;
                    section.data(3).dtTransOffset = 2;

                    ;% rtDW.cvomrxhs42
                    section.data(4).logicalSrcIdx = 70;
                    section.data(4).dtTransOffset = 3;

                    ;% rtDW.azflf0jxhk
                    section.data(5).logicalSrcIdx = 71;
                    section.data(5).dtTransOffset = 4;

            nTotData = nTotData + section.nData;
            dworkMap.sections(5) = section;
            clear section

            section.nData     = 4;
            section.data(4)  = dumData; %prealloc

                    ;% rtDW.hyn34tqyhg
                    section.data(1).logicalSrcIdx = 72;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.egcop1hidl
                    section.data(2).logicalSrcIdx = 73;
                    section.data(2).dtTransOffset = 7;

                    ;% rtDW.khtwmdpm1n
                    section.data(3).logicalSrcIdx = 74;
                    section.data(3).dtTransOffset = 14;

                    ;% rtDW.afcsqes2su
                    section.data(4).logicalSrcIdx = 75;
                    section.data(4).dtTransOffset = 15;

            nTotData = nTotData + section.nData;
            dworkMap.sections(6) = section;
            clear section

            section.nData     = 4;
            section.data(4)  = dumData; %prealloc

                    ;% rtDW.pg5uo13xab
                    section.data(1).logicalSrcIdx = 76;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.jnwrh0mkqe
                    section.data(2).logicalSrcIdx = 77;
                    section.data(2).dtTransOffset = 1;

                    ;% rtDW.iqnjz320h2
                    section.data(3).logicalSrcIdx = 78;
                    section.data(3).dtTransOffset = 2;

                    ;% rtDW.h31w2dd5tc
                    section.data(4).logicalSrcIdx = 79;
                    section.data(4).dtTransOffset = 3;

            nTotData = nTotData + section.nData;
            dworkMap.sections(7) = section;
            clear section


            ;%
            ;% Non-auto Data (dwork)
            ;%


        ;%
        ;% Add final counts to struct.
        ;%
        dworkMap.nTotData = nTotData;



    ;%
    ;% Add individual maps to base struct.
    ;%

    targMap.paramMap  = paramMap;
    targMap.signalMap = sigMap;
    targMap.dworkMap  = dworkMap;

    ;%
    ;% Add checksums to base struct.
    ;%


    targMap.checksum0 = 2179576693;
    targMap.checksum1 = 1618255638;
    targMap.checksum2 = 1620430009;
    targMap.checksum3 = 730558578;

