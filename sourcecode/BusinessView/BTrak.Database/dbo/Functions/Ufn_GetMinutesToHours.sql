CREATE FUNCTION [dbo].[Ufn_GetMinutesToHours](
       @minutes int
   )
   RETURNS VARCHAR(20)
   AS
   BEGIN
       DECLARE @hours INT
       SET @hours = (@minutes / 60)
       RETURN CASE WHEN @hours = '0' THEN FORMAT (@minutes - @hours * 60, '00') + 'min' ELSE  FORMAT (@hours, '0') + 'hr' END
   END