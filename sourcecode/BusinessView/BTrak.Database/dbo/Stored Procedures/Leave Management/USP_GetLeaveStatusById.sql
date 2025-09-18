CREATE PROCEDURE [dbo].[USP_GetStatusById]
(
  @CompanyId UNIQUEIDENTIFIER = NULL,
  @StatusId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
     BEGIN TRY
	  SELECT Id,
		         [Status],
				 StatusColor,
				 --IsArchived
				 CompanyId,
				 CreatedDatetime,
				 CreatedByUserId
		  FROM  [dbo].[UserStoryStatus] WITH (NOLOCK)
		  WHERE   CompanyId = @CompanyId 
		      AND Id = @StatusId
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