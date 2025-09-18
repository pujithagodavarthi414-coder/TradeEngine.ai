--EXEC [GetGoalComments] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308'
CREATE PROCEDURE [dbo].[USP_GetGoalComments]
(
  @GoalId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @GoalCommentId UNIQUEIDENTIFIER = NULL,
  @Searchtext NVARCHAR(50) = NULL,
  @IsArchived BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
	BEGIN TRY
		
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN

		SET @Searchtext = '%'+@Searchtext+'%'

		SELECT GC.Id AS GoalCommentId,
		       GoalId,
		       Comments,
			   U.[FirstName] + ' ' + ISNULL(U.SurName,'') AS Username,
			   U.ProfileImage,
			   GC.CreatedByUserId,
			   GC.CreatedDateTime AS CommentedDateTime,
			   GC.[TimeStamp]
			   FROM GoalComments GC
			   JOIN [User] U ON U.Id = GC.CreatedByUserId 
			   WHERE (@GoalId IS NULL OR GC.GoalId = @GoalId)
			     AND (@Searchtext IS NULL OR (@Searchtext IS NULL OR GC.Comments LIKE @Searchtext)) 
				 AND (@IsArchived IS NULL 
				  OR (@IsArchived = 0 AND GC.InactiveDateTime IS NULL) 
				  OR (@IsArchived = 1 AND GC.InactiveDateTime IS NOT NULL))
			   ORDER BY GC.CreatedDateTime DESC

			END
			ELSE
			
				RAISERROR(@HavePermission,11,1)

           END TRY
		   BEGIN CATCH
		
			THROW

		   END CATCH
END