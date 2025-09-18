-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Save or Update the BoardTypeUi
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertEntityRole]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@EntityRoleName='GRP'
CREATE PROCEDURE [dbo].[USP_UpsertEntityRole]
(
  @EntityRoleId UNIQUEIDENTIFIER = NULL,
  @EntityRoleName NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL,
  @IsArchived BIT = NULL
)
AS
BEGIN
    
	SET NOCOUNT ON
    
	BEGIN TRY
    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        IF(@IsArchived IS NULL) SET @IsArchived = 0
		IF(@HavePermission = '1')
        BEGIN
                    
			DECLARE @Currentdate DATETIME = GETDATE()
        
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        
			DECLARE @EntityRoleIdCount INT = (SELECT COUNT(1) FROM [dbo].[EntityRole] WHERE Id = @EntityRoleId)
        
			DECLARE @EntityRoleNameCount INT = (SELECT COUNT(1) FROM [dbo].[EntityRole] WHERE EntityRoleName = @EntityRoleName AND CompanyId = @CompanyId  AND (@EntityRoleId IS NULL OR Id <> @EntityRoleId ) AND InActiveDateTime IS NULL)
        
			IF(@EntityRoleIdCount = 0 AND @EntityRoleId IS NOT NULL)
			BEGIN
            
				RAISERROR(50002,16, 1,'EntityRole')
        
			END
			ELSE IF(@EntityRoleNameCount > 0)
			BEGIN
            
				RAISERROR(50001,16,1,'EntityRole')
        
			END
			ELSE
			BEGIN
            
				DECLARE @IsLatest BIT = (CASE WHEN @EntityRoleId IS NULL
									  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
															   FROM [EntityRole] WHERE Id = @EntityRoleId) = @TimeStamp
														THEN 1 ELSE 0 END END)
				IF(@IsLatest = 1)
				BEGIN
                
					IF(@EntityRoleId IS NULL)
					BEGIN
            
						SET @EntityRoleId = NEWID()
							INSERT INTO [dbo].[EntityRole](
										Id,
										EntityRoleName,
										CompanyId,
										CreatedDateTime,
										CreatedByUserId
										)
								 SELECT @EntityRoleId,
										@EntityRoleName,
										@CompanyId,
										@Currentdate,
										@OperationsPerformedBy

					END
					ELSE
					BEGIN
						
						UPDATE [dbo].[EntityRole]
						SET EntityRoleName      =      @EntityRoleName,
							CompanyId           =      @CompanyId,
							UpdatedDateTime     =      @Currentdate,
							UpdatedByUserId     =      @OperationsPerformedBy,
							InActiveDateTime	=	   CASE WHEN @IsArchived = 0 THEN NULL ELSE @Currentdate END
						WHERE Id = @EntityRoleId

					END
            
					SELECT Id FROM [dbo].[EntityRole] WHERE Id = @EntityRoleId
        
				END
				ELSE
				BEGIN
					   RAISERROR (50008,11, 1)
				END
			END
        END
        ELSE
        BEGIN
             
			 RAISERROR (@HavePermission,10, 1)
        
		END
    END TRY
    BEGIN CATCH
        
		THROW
    
	END CATCH
END