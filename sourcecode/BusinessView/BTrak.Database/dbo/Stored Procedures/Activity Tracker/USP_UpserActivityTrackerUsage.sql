CREATE PROCEDURE [dbo].[USP_UpserActivityTrackerUsage]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER
    ,@IdsXML XML = NULL
)
AS
BEGIN
    
    SET NOCOUNT ON

    BEGIN TRY
        
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF(@HavePermission = '1')
        BEGIN
            
            IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

            IF(@IdsXML IS NULL)
            BEGIN

                RAISERROR(50011,16, 2, 'ActivityIds')

            END
            ELSE
            BEGIN

                UPDATE UserActivityTrackerStatus SET IsLogged = 1
                FROM UserActivityTrackerStatus ATS
                     INNER JOIN @IdsXML.nodes('/IdleTimeRecordsXML/IdleTimeRecords/Id') XmlData(X) 
                 ON X.value('text()[1]','UNIQUEIDENTIFIER') = ATS.Id
            
   END

        END
        ELSE
        BEGIN

              RAISERROR (@HavePermission,11, 1)

         END

    END TRY
    BEGIN CATCH

        THROW

    END CATCH

END
GO

