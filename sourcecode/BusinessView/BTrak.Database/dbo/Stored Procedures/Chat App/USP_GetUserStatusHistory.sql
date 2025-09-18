--------------------------------------------------------------------------------------------------
-- Author       Vikkiendhar BasiReddyGari
-- Created      '2020-06-08 00:00:00.000'
-- Purpose      To fetch user status history for past 30 days
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
--------------------------------------------------------------------------------------------------
--EXEC USP_GetUserStatusHistory @UserId = '0b2921a9-e930-4013-9047-670b5352f308',
--						@OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308'
--------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStatusHistory]
(
    @UserId UNIQUEIDENTIFIER = NULL, 
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
            IF (@HavePermission = '1')
            BEGIN
                IF (@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

			    IF (@UserId IS NULL)
				    BEGIN
					    RAISERROR('UserIdShouldNotBeNull',11,1)
				    END
                ELSE
                    BEGIN
                        DECLARE @CompanyId UNIQUEIDENTIFIER

                        SELECT @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

                        SELECT 
                        UOS.StatusName AS [Status],
                        P.[PlatformName],
                        MA.CreatedDateTime,
                        MA.IpAddress
                        FROM [MessengerAudit] MA
                        INNER JOIN [UserOnlineStatus] UOS ON MA.StatusId = UOS.Id
                                  AND UOS.[InActiveDateTime] IS NULL
                        INNER JOIN [Platform] P ON MA.PlatformId = P.Id
                                  AND UOS.[InActiveDateTime] IS NULL
                        WHERE MA.CompanyId = @CompanyId
                              AND MA.UserId = @UserId
                              AND MA.CreatedDateTime BETWEEN DATEADD(DAY,-30,GETDATE()) AND GETDATE()
                        ORDER BY MA.CreatedDateTime DESC
                    END
            END
            ELSE
            BEGIN
                RAISERROR(@HavePermission,11,1)
            END
     END TRY
     BEGIN CATCH
        
           THROW

    END CATCH
END
GO