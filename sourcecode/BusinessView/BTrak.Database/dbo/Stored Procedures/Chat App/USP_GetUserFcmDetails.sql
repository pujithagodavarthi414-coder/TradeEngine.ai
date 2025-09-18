CREATE PROCEDURE [dbo].[USP_GetUserFcmDetails]
@UserId NVARCHAR(max),
@IsFromBtrakMobile BIT,
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN   
    SET NOCOUNT ON;
	 
	 --DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	 --IF(@HavePermission = '1')
  --   BEGIN

	 IF(@IsFromBtrakMobile=1)
	  SELECT *  from [dbo].[UserFcmDetails]UFD WHERE UFD.UserId = @UserId and UFD.IsDelete = 0 and UFD.IsFromBTrakMobile=1
	 else
	    SELECT *  from [dbo].[UserFcmDetails]UFD WHERE UFD.UserId = @UserId and UFD.IsDelete = 0 and UFD.IsFromBTrakMobile!=1
	  
  --   END
	 --ELSE
	 --BEGIN
	 
	 --     RAISERROR (@HavePermission,10, 1)
	 
	 --END         
end