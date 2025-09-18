CREATE PROCEDURE [dbo].[USP_UpdatePassword]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @ChangedToUserId UNIQUEIDENTIFIER = NULL,
    @ResetGuid UNIQUEIDENTIFIER = NULL,
    @OldPassword NVARCHAR(250) = NULL,
    @NewPassword NVARCHAR(250) = NULL,
    @ConfirmPassword NVARCHAR(250) = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @IsArchived BIT = NULL
)
AS
BEGIN
        SET NOCOUNT ON
       
        BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
	    BEGIN
		  
        IF(@ResetGuid IS NOT NULL) SET @ChangedToUserId = (SELECT UserId FROM ResetPassword WHERE ResetGuid = @ResetGuid)
        
		IF (@TimeStamp IS NULL) SET @TimeStamp = (SELECT [TimeStamp] FROM [User] WHERE Id = @ChangedToUserId AND InActiveDateTime IS NULL)

        DECLARE @IsLatest BIT = 1 --(CASE WHEN (SELECT [TimeStamp] FROM [User] WHERE Id = ISNULL(@ChangedToUserId,@OperationsPerformedBy)) = @TimeStamp THEN 1 ELSE 0 END)
     
        IF(@IsLatest = 1)
        BEGIN
            DECLARE @Currentdate DATETIME = GETDATE()
            
					UPDATE [User]
					   SET [Password] = @NewPassword,
					       [UpdatedByUserId] = ISNULL(@ChangedToUserId,@OperationsPerformedBy),
						   [UpdatedDateTime] = @Currentdate
						   WHERE Id = ISNULL(@ChangedToUserId,@OperationsPerformedBy) 

			IF(@ResetGuid IS NOT NULL)
            BEGIN
            UPDATE ResetPassword SET IsExpired = 1 Where ResetGuid = @ResetGuid
            END
			    
     --         INSERT INTO UsefulFeatureAudit(Id,UsefulFeatureId,CreatedByUserId,CreatedDateTime)
			  --VALUES(NEWID(),(SELECT Id FROM UsefulFeature WHERE FeatureName = 'Number of change passwords'),@OperationsPerformedBy,@Currentdate)


            SELECT Id FROM [dbo].[User] WHERE Id = ISNULL(@ChangedToUserId,@OperationsPerformedBy) 

			IF(@ResetGuid IS NOT NULL)
            BEGIN
            UPDATE ResetPassword SET IsExpired = 1 Where ResetGuid = @ResetGuid
            END

            END 
            ELSE
                RAISERROR (50008,11, 1)
         
	   END	 
       END TRY  
       BEGIN CATCH 
        
           THROW
      END CATCH
END