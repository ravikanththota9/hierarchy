IF Object_id('client_view_data') IS NOT NULL
  BEGIN
      DROP PROCEDURE client_view_data

      IF Object_id('client_view_data') IS NOT NULL
        PRINT '<<< FAILED dropping Procedure client_view_data >>>'
      ELSE
        PRINT '<<< DROPPED Procedure client_view_data >>>'
  END

go
------------------------------------------------------------------ Define SP --  
CREATE PROCEDURE client_view_data
(@inReqParam          varchar(50))  
 AS  
  BEGIN TRY  
      SET nocount ON 



DROP TABLE finaltable
create table finaltable (CG int , LE int , TE int , CGname varchar(80), LEname varchar(80) , TEname varchar(80))

DROP TABLE tdtemp
create table tdtemp(wildid int, cmdid int , tradingentityname varchar(50))

insert into tdtemp
select wildid,cmdid,tradingentityname from tradingentity where tradingentityname like '%'+@inReqParam+'%' 

--SELECT * FROM tdtemp

DROP TABLE distinct_cmdid
 SELECT distinct cmdid  
      INTO distinct_cmdid  
      FROM   tdtemp  
       
--select * from   distinct_cmdid  

DROP TABLE letemp
create table letemp(cmdid int , cgid int , lename varchar(50))

insert into letemp
select cmdid,clientgroupid,legalentityname from legalentity where cmdid in (select cmdid from   distinct_cmdid  )

--select * from letemp

DROP TABLE distinct_cgid
SELECT distinct cgid  
      INTO distinct_cgid  
      FROM   letemp

--select * from distinct_cgid

Drop table cgtemp
create table cgtemp(cgid int,cgname varchar(50))

insert into cgtemp
select clientgropuid,clientgroupname from clientgroup where clientgropuid in (select cgid from distinct_cgid) 

--select * from cgtemp


DECLARE @wildidtemp varchar(50)
DECLARE @tradingentitynameTEMP varchar(50)
DECLARE @cmdidtemp INT
Declare @cgidtemp INT
Declare @cgnametemp varchar(50)
declare @lenametemp varchar(50)
DECLARE @parentID INT 
set @parentID = 1;

DECLARE @childID INT 
set @childID = 1;

DECLARE @subchildid INT 
set @subchildid = 1;



WHILE EXISTS (select * from cgtemp)
     BEGIN 
			SELECT TOP 1 @cgidtemp =  cgid,@cgnametemp = cgname  FROM  cgtemp
			PRINT(@cgidtemp)  
          WHILE Exists (select * from   letemp where cgid = @cgidtemp)
            BEGIN
				SELECT TOP 1 @cmdidtemp =  cmdid,@lenametemp = lename FROM  letemp
				PRINT(@cmdidtemp)
							
               WHILE Exists (select * from tdtemp where cmdid = @cmdidtemp)
				begin
					SELECT TOP 1 @wildidtemp =  wildid,@tradingentitynameTEMP = tradingentityname  FROM  tdtemp				
					insert into finaltable values (@parentID,@childID,@subchildid,@cgnametemp,@lenametemp,@tradingentitynameTEMP)
					set @subchildid = @subchildid+1;
					PRINT(@wildidtemp + @tradingentitynameTEMP)
					delete from tdtemp where wildid = @wildidtemp
				end
				
				delete from  letemp where cmdid = @cmdidtemp  
				set @childID = @childID+1;
				set @subchildid = 1;
            END
       delete from cgtemp where cgid = @cgidtemp  
       set @parentID = @parentID+1;
       set @childID = 1;
     END
    
      
 select * from finaltable  
 
 END TRY  
  
  BEGIN CATCH  
      DECLARE @ErrorMessage NVARCHAR(4000),  
              @ErrSeverity  INT 
     
      SELECT @ErrorMessage = Error_message(),  
             @ErrSeverity = Error_severity()  
  
      RAISERROR(@ErrorMessage,@ErrSeverity,1)  
  END CATCH -- client_view_data    
go
---------------------------------------- Check that procedure was created ------
IF Object_id('client_view_data') IS NOT NULL
    print '<<< CREATED procedure client_view_data >>>'
ELSE
    print '<<< FAILED creating procedure client_view_data>>>'
go

  
 
  