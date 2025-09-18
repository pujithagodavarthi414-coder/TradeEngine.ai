CREATE PROCEDURE [dbo].[USP_GetAllStatus]
(
  @CompanyId UNIQUEIDENTIFIER ,
  @IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
     BEGIN TRY

	 IF(@IsArchived IS NULL OR @IsArchived = '') SET @IsArchived = 0
	      SELECT Id,
		         [Status],
				 StatusColor,
				 --IsArchived
				 CompanyId,
				 CreatedDatetime,
				 CreatedByUserId

		  FROM  [dbo].[UserStoryStatus] WITH (NOLOCK)
		  WHERE CompanyId = @CompanyId 
		        --AND  IsArchived = @IsArchived
	 END TRY  
	 BEGIN CATCH 
		
		SELECT ERROR_NUMBER() AS ErrorNumber,
			   ERROR_SEVERITY() AS ErrorSeverity, 
			   ERROR_STATE() AS ErrorState,  
			   ERROR_PROCEDURE() AS ErrorProcedure,  
			   ERROR_LINE() AS ErrorLine,  
			   ERROR_MESSAGE() AS ErrorMessage

	END CATCH
END