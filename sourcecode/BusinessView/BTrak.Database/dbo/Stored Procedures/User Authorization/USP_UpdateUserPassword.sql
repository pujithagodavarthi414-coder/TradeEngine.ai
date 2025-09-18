create PROCEDURE [dbo].[USP_UpdateUserPassword]
(
    @Id UNIQUEIDENTIFIER,
    @Password NVARCHAR(250),
    @UpdatedDateTime DATETIME,
    @UpdatedByUserId UNIQUEIDENTIFIER
)
AS
BEGIN
    
    SET NOCOUNT ON;
	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@UpdatedByUserId,(SELECT OBJECT_NAME(@@PROCID))))
    
	IF (@HavePermission = '1')
	BEGIN

    UPDATE [User] SET Password=@Password,UpdatedDateTime=@UpdatedDateTime,UpdatedByUserId=@UpdatedByUserId WHERE Id=@Id;

    INSERT INTO UsefulFeatureAudit(Id,UsefulFeatureId,CreatedByUserId,CreatedDateTime)
	VALUES(NEWID(),(SELECT Id FROM UsefulFeature WHERE FeatureName = 'Number of change passwords'),@UpdatedByUserId,@UpdatedDateTime)

	END
    ELSE
    BEGIN
    
	RAISERROR (@HavePermission,11, 1)
   
   END
END