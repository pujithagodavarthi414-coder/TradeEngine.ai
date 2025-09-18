CREATE PROCEDURE [dbo].[USP_DeleteRole]
(
  @RoleId UNIQUEIDENTIFIER,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @CompanyId UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
        BEGIN
         
		    DECLARE @RoleIdCount INT = (SELECT COUNT(1) FROM [Role] WHERE Id = @RoleId AND InActiveDateTime IS NULL)

			DECLARE @RoleIdCountForUsers INT  = (SELECT COUNT(1) FROM UserRole WHERE RoleId = @RoleId AND InactiveDateTime IS NULL)
            
            IF(@RoleIdCount = 0 AND @RoleId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'RoleId')
            
            END
			ELSE IF(@IsArchived = 1 AND @RoleIdCountForUsers > 0)
			 BEGIN
			 
				RAISERROR('ThisRoleIsLinkedToUsers',11,1)
			 
			END
            ELSE
            BEGIN
                DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
                IF (@HavePermission = '1')
                BEGIN
                
                    DECLARE @Currentdate DATETIME = GETDATE()
                        
                    DECLARE @IsLatest BIT = '1'
                       
                    IF(@IsLatest = 1)
                    BEGIN                                                 
                     
						UPDATE [dbo].[Role] SET	[InactiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
                                                [UpdatedDateTime]  = @Currentdate,
                                                [UpdatedByUserId]  = @OperationsPerformedBy 
                                            WHERE Id = @RoleId AND CompanyId = @CompanyId

						UPDATE RoleFeature SET	InActiveDateTime = @CurrentDate,
												UpdatedByUserId = @OperationsPerformedBy,
												UpdatedDateTime = @Currentdate
										   WHERE RoleId = @RoleId
                               
                        SELECT Id FROM [dbo].[Role] where Id = @RoleId
            
                    END
                    ELSE 
            
                        RAISERROR (50015,11, 1)
            
                END
                ELSE
            
                    RAISERROR (@HavePermission,11, 1)
            END
        END
    END TRY  
    BEGIN CATCH 
        
           THROW
    END CATCH
END
GO