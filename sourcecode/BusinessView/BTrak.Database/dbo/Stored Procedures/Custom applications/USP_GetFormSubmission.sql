-------------------------------------------------------------------------------
-- Author       Anupam sai kumar Vuyyuru
-- Created      '2020-02-03 00:00:00.000'
-- Purpose      To Get the ObservationTypes By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetFormSubmission]
(
  @FormSubmissionId UNIQUEIDENTIFIER = NULL,
  @AssignedByYou BIT = NULL,
  @SearchText NVARCHAR(500) = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection NVARCHAR(50)=NULL,
  @PageNumber INT = 1,
  @PageSize INT = 30,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @IsArchived BIT = NULL	
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	   IF(@SearchText = '') SET  @SearchText = NULL
		     
	   SET @SearchText = '%'+ @SearchText +'%'

	   IF(@SortBy IS NULL) SET @SortBy = 'latestModificationOn'
		     
	   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
		     
            
      IF (@HavePermission = '1')
      BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	       SELECT FS.Id AS FormSubmissionId,
		          FS.GenericFormId,
				  FS.FormData,
				  GF.FormJson,
				  GF.FormName,
				  FT.FormTypeName,
				  FS.[Status],
		          FS.AssignedToUserId,
				  ATU.FirstName + ' ' + ISNULL(ATU.SurName,'') AS AssignedToUserName,
				  ATU.ProfileImage AS AssignedToUserImage,
				  FS.AssignedByUserId,
				  ABU.FirstName + ' ' + ISNULL(ABU.SurName,'') AS AssignedByUserName,
				  ABU.ProfileImage AS AssignedByUserImage,
				  FS.CreatedByUserId,
				  FS.CreatedDateTime,
				  ISNULL(FS.UpdatedDateTime,FS.CreatedDateTime) AS LastestModificationOn,
				  CASE WHEN FS.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
		   FROM  [dbo].FormSubmissions FS WITH (NOLOCK)
				 JOIN GenericForm GF ON GF.Id = FS.GenericFormId
				 JOIN FormType FT ON GF.FormTypeId = FT.Id
				 JOIN [User] ABU ON ABU.Id = FS.AssignedByUserId
				 LEFT JOIN [User] ATU ON ATU.Id = FS.AssignedToUserId
		   WHERE ((@FormSubmissionId IS NULL OR FS.Id = @FormSubmissionId))
		         AND ((@AssignedByYou IS NULL) OR (@AssignedByYou = 1 AND FS.CreatedByUserId = @OperationsPerformedBy) OR (@AssignedByYou = 0 AND FS.AssignedToUserId = @OperationsPerformedBy AND FS.CreatedByUserId <> @OperationsPerformedBy))
				 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND FS.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND FS.InActiveDateTime IS NULL))
				 AND  (@SearchText IS NULL 
							  OR (GF.FormName LIKE @SearchText)
							  OR (FT.FormTypeName LIKE @SearchText)
							  OR (@AssignedByYou = 1 AND ATU.FirstName + ' ' + ISNULL(ATU.SurName,'') LIKE @SearchText)
							  OR (@AssignedByYou = 0 AND ABU.FirstName + ' ' + ISNULL(ABU.SurName,'') LIKE @SearchText)
							  OR (FS.[Status] LIKE @SearchText)
							  )
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		  	  			CASE WHEN @SortBy = 'latestModificationOn' THEN CAST(ISNULL(FS.UpdatedDateTime,FS.CreatedDateTime) AS sql_variant)
		  	  			     WHEN @SortBy = 'formeName' THEN  GF.FormName
		  	  			     WHEN @SortBy = 'formTypeName' THEN  FT.FormTypeName
		  	  			     WHEN @SortBy = 'assignedTo' THEN  ATU.FirstName + ' ' + ISNULL(ATU.SurName,'')
		  	  			     WHEN @SortBy = 'assignedBy' THEN  ABU.FirstName + ' ' + ISNULL(ABU.SurName,'')
		  	  			     WHEN @SortBy = 'status' THEN  [Status]
		  	  			END
		  	  	  END ASC,
		  	  	  CASE WHEN @SortDirection = 'DESC' THEN
		  	  			CASE WHEN @SortBy = 'latestModificationOn' THEN CAST(ISNULL(FS.UpdatedDateTime,FS.CreatedDateTime) AS sql_variant)
		  	  			     WHEN @SortBy = 'formeName' THEN  GF.FormName
		  	  			     WHEN @SortBy = 'formTypeName' THEN  FT.FormTypeName
		  	  			     WHEN @SortBy = 'assignedTo' THEN  ATU.FirstName + ' ' + ISNULL(ATU.SurName,'')
		  	  			     WHEN @SortBy = 'assignedBy' THEN  ABU.FirstName + ' ' + ISNULL(ABU.SurName,'')
		  	  			     WHEN @SortBy = 'status' THEN  [Status]
		  	  			END
		  	  	  END DESC
				 OFFSET ((@PageNumber - 1) * @PageSize) ROWS		        
                FETCH NEXT @PageSize ROWS ONLY
	 
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