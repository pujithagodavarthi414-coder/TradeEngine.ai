CREATE PROCEDURE [dbo].[USP_ChannelArchive]
(
	@Id uniqueidentifier,
	@OperationsPerformedBy uniqueidentifier = NULL
)

AS

SET NOCOUNT ON

   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		  
   IF (@HavePermission = '1')
   BEGIN
     
	 Update [Channel] set IsDeleted = 1
     WHERE [Id] = @Id

	END     
	ELSE 
	BEGIN

	   RAISERROR (@HavePermission,11, 1)

	END