CREATE FUNCTION [dbo].[Ufn_GetChildAuditCategories]
(
	@AuditCategoryId UNIQUEIDENTIFIER,
	@IsForAudits BIT,
	@AuditComplianceVersionId UNIQUEIDENTIFIER,
	@IsFromAuditVersions BIT
)
RETURNS @AuditChilds TABLE
(
	AuditCategoryId UNIQUEIDENTIFIER
)
AS
BEGIN
	
	IF(@IsFromAuditVersions = 1 AND @AuditComplianceVersionId IS NOT NULL)
	BEGIN
		
		;WITH AuditCategories AS(
	                          SELECT @AuditCategoryId AS AuditCategoryId
							  
							  UNION ALL

							  SELECT AC.Id AS AuditCategoryId 
							  FROM AuditCategories ATC
								   INNER JOIN AuditCategoryVersions AC ON AC.ParentAuditCategoryId = ATC.AuditCategoryId
							  WHERE ATC.AuditCategoryId IS NOT NULL
							        AND AC.AuditComplianceVersionId = @AuditComplianceVersionId
	                        )
	INSERT @AuditChilds
	SELECT AuditCategoryId FROM AuditCategories GROUP BY AuditCategoryId

	END
	ELSE IF(@IsForAudits = 1)
	BEGIN
	;WITH AuditCategories AS(
	                          SELECT @AuditCategoryId AS AuditCategoryId
							  
							  UNION ALL

							  SELECT AC.Id AS AuditCategoryId FROM 
							  AuditCategories ATC
							  JOIN AuditCategory AC ON AC.ParentAuditCategoryId = ATC.AuditCategoryId
							  WHERE ATC.AuditCategoryId IS NOT NULL
	                        )
	INSERT @AuditChilds
	SELECT AuditCategoryId FROM AuditCategories GROUP BY AuditCategoryId

	END
	ELSE
	BEGIN

		;WITH AuditCategories AS(
	                          SELECT @AuditCategoryId AS AuditCategoryId
							  
							  UNION ALL

							  SELECT AC.AuditCategoryId FROM 
							  AuditCategories ATC
							  JOIN AuditConductSelectedCategory AC ON AC.ParentAuditCategoryId = ATC.AuditCategoryId
							  WHERE ATC.AuditCategoryId IS NOT NULL
	                        )

		INSERT @AuditChilds
	    SELECT AuditCategoryId FROM AuditCategories GROUP BY AuditCategoryId

	END

	RETURN
END
