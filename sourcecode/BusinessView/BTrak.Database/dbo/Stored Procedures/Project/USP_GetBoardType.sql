CREATE PROCEDURE [dbo].[USP_GetBoardType]
(
	@CompanyId UNIQUEIDENTIFIER = NULL,
	@BoardTypeUIId UNIQUEIDENTIFIER = NULL,
	@BoardTypeName NVARCHAR(250) = NULL
)
AS
BEGIN
  SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	      IF (@BoardTypeUIId = '00000000-0000-0000-0000-000000000000') SET @BoardTypeUIId = NULL

	      IF (@BoardTypeName = '') SET @BoardTypeName = NULL

          SELECT B.Id AS BoardTypeId,
                 B.BoardTypeName,
                 CASE WHEN B.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                 B.BoardTypeUIId,
                 B.CompanyId,
                 B.CreatedDatetime,
                 B.CreatedByUserId,
				 B.UpdatedByUserId,
				 B.UpdatedDateTime,
				 TotalCount = COUNT(1) OVER()
          FROM  [dbo].[BoardType] B WITH (NOLOCK)
          WHERE (@BoardTypeUIId IS NULL OR Id = @BoardTypeUIId) 
		        AND (@BoardTypeName IS NULL OR BoardTypeName = @BoardTypeName)
			    AND CompanyId = @CompanyId 
     END TRY
     BEGIN CATCH
        
        SELECT ERROR_NUMBER() AS ErrorNumber,
               ERROR_SEVERITY() AS ErrorSeverity,
               ERROR_STATE() AS ErrorState,
               ERROR_PROCEDURE() AS ErrorProcedure,
               ERROR_LINE() AS ErrorLine,
               ERROR_MESSAGE() AS ErrorMessage

    END CATCH
END
GO