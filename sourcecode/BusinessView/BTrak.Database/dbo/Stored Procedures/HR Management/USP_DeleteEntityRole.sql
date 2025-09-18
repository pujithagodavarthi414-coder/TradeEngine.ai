----------------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-02-04 00:00:00.000'
-- Purpose      To Delete Entity Role
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------
 --EXEC [dbo].[USP_DeleteEntityRole] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
 --@EntityRoleId = 'E8F06017-01FD-4E9E-BDCB-9497481F31ED',@TimeStamp = 0x0000000000000867,
----------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_DeleteEntityRole]
(
  @EntityRoleId UNIQUEIDENTIFIER,
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
         
		    DECLARE @EntityRoleIdCount INT = (SELECT COUNT(1) FROM [EntityRole] WHERE Id = @EntityRoleId AND InActiveDateTime IS NULL)
            
			DECLARE @EntityRoleIdCountInUserProject INT  = (SELECT COUNT(1) FROM UserProject WHERE EntityRoleId = @EntityRoleId AND InactiveDateTime IS NULL)

            IF(@EntityRoleIdCount = 0 AND @EntityRoleId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'EntityRoleId')
            
            END
			ELSE IF(@IsArchived = 1 AND @EntityRoleIdCountInUserProject > 0)
			BEGIN
			 
				RAISERROR('ThisEntityRoleIsLinkedToUserProject',11,1)
			 
			END
            ELSE
            BEGIN
                DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
                IF (@HavePermission = '1')
                BEGIN
                
                    DECLARE @Currentdate DATETIME = GETDATE()
                        
                    DECLARE @IsLatest BIT = (CASE WHEN (SELECT ER.[TimeStamp] FROM [EntityRole] ER WHERE ER.Id = @EntityRoleId AND ER.CompanyId = @CompanyId) = @TimeStamp THEN 1 ELSE 0 END)
                       
                    IF(@IsLatest = 1)
                    BEGIN                                                 
                     
						UPDATE [dbo].[EntityRole] SET	[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
													    [UpdatedDateTime]  = @Currentdate,
													    [UpdatedByUserId]  = @OperationsPerformedBy 
												  WHERE Id = @EntityRoleId

						UPDATE EntityRoleFeature SET InactiveDateTime = @Currentdate,
													 UpdatedByUserId = @OperationsPerformedBy,
													 UpdatedDateTime = @Currentdate 
												 WHERE EntityRoleId = @EntityRoleId
                               
                        SELECT Id FROM [dbo].[EntityRole] where Id = @EntityRoleId
            
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