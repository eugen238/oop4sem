CREATE PFILE = 'DEA_PFILE.ORA' FROM SPFILE;

CREATE SPFILE = 'DEA_SPFILE2.ORA' FROM PFILE='DEA_PFILE.ORA';

SELECT name FROM v$controlfile;


-- ���������� ���� ������
SHUTDOWN IMMEDIATE;

-- ������� ��������� ����� �������� ������������ �����
cp C:\Oracle21c\oradata\DEM\CONTROL01.CTL C:\Oracle21c\oradata\DEM\CONTROL01.CTL.bak

-- ������� ���� �� ����������� ������ 
ALTER DATABASE
    REMOVE FILE 'C:\Oracle21c\oradata\DEM\CONTROL01.CTL';

-- �������� ����� ����������� ���� 
ALTER DATABASE
    ADD FILE 'C:\Oracle21c\oradata\DEM\CONTROL03.CTL' SIZE 50M REUSE;

-- ��������� ���� ������
STARTUP;

-- "C:\Oracle21c\database\PWDdem.ora"

SHOW PARAMETER password_file;

select * from v$diag_info;

-- "C:\Oracle21c\diag\rdbms\dem\dem\alert\log.xml"