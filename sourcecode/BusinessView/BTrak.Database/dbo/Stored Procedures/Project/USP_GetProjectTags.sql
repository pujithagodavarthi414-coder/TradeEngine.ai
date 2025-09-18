CREATE PROCEDURE USP_GetProjectTags
(
 @ProjectId UNIQUEIDENTIFIER = NULL,
 @Tag NVARCHAR(250) = NULL,
 @SearchText NVARCHAR(250) = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF(@HavePermission = '1')
        BEGIN

        DECLARE @ProjectCount INT = (SELECT COUNT(1) FROM Project WHERE Id = @ProjectId)

        IF(@ProjectCount = 1)
        BEGIN

        SELECT @ProjectId AS ProjectId,Id AS Tag FROM UfnSplit((SELECT Tag FROM Project 
                                         WHERE Id = @ProjectId))
         WHERE (@Tag IS NULL OR (Id = @Tag))
         AND (@SearchText IS NULL OR (Id LIKE '%' + @SearchText + '%'))

        END
        ELSE
            
            RAISERROR(50002,11,1,'Project')

        END
        ELSE

            RAISERROR(@HavePermission,11,1)

    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO