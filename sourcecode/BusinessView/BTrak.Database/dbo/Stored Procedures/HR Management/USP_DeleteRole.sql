----------------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-02-04 00:00:00.000'
-- Purpose      To Delete Role
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------
 --EXEC [dbo].[USP_DeleteRole] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
 --@RoleId = 'E8F06017-01FD-4E9E-BDCB-9497481F31ED',@TimeStamp = 0x0000000000000867,
----------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_DeleteRole]
(
  @RoleId UNIQUEIDENTIFIER,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        
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
                DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
                IF (@HavePermission = '1')
                BEGIN
                
                    DECLARE @Currentdate DATETIME = GETDATE()
                        
                    DECLARE @IsLatest BIT = (CASE WHEN (SELECT R.[TimeStamp] FROM [Role] R WHERE R.Id = @RoleId AND R.CompanyId = @CompanyId) = @TimeStamp THEN 1 ELSE 0 END)
                       
                    IF(@IsLatest = 1)
                    BEGIN                                                 
                     
						UPDATE [dbo].[Role] SET	[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
                                                [UpdatedDateTime]  = @Currentdate,
                                                [UpdatedByUserId]  = @OperationsPerformedBy 
                                            WHERE Id = @RoleId

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