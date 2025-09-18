CREATE PROCEDURE [dbo].USP_GetErrorInformation
AS
BEGIN

   --SELECT ERROR_MESSAGE() AS ErrorMessage,
   --       ERROR_SEVERITY() AS ErrorSeverity,
   --       ERROR_STATE() AS ErrorState,
   --       ERROR_LINE () AS ErrorLine,
   --       ERROR_PROCEDURE() AS ErrorProcedure,
		 -- ERROR_NUMBER() AS ErrorNumber

		DECLARE @Value1  NVARCHAR(500) = ERROR_MESSAGE()
		DECLARE @Value2  INT = ERROR_SEVERITY()
		DECLARE @Value3  INT  = ERROR_STATE()		
 
		RAISERROR (@Value1,@Value2,@Value3)
 
   --SELECT ERROR_NUMBER() AS ErrorNumber,
   --       ERROR_SEVERITY() AS ErrorSeverity,
   --       ERROR_STATE() AS ErrorState,
   --       ERROR_LINE () AS ErrorLine,
   --       ERROR_PROCEDURE() AS ErrorProcedure,
   --       ERROR_MESSAGE() AS ErrorMessage


END