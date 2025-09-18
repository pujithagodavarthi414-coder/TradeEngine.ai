CREATE FUNCTION [dbo].[Ufn_GetMinutesToHHMM](
       @minutes int
   )
   RETURNS VARCHAR(20)
   AS
   BEGIN
       DECLARE @hours INT
       SET @hours = (@minutes / 60)
       RETURN CASE WHEN @hours = '0' THEN FORMAT (@minutes - @hours * 60, '00') + 'm' 
	   WHEN @hours < 10 THEN + '0' + FORMAT (@hours, '0') + 'h:' + FORMAT (@minutes - @hours * 60, '00') + 'm' 
	   ELSE FORMAT (@hours, '0') + 'h:' + FORMAT (@minutes - @hours * 60, '00') + 'm' END
   END