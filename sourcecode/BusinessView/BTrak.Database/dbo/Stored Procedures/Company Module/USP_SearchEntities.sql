--EXEC [dbo].[USP_SearchEntities] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_SearchEntities]
(	
	@EntityId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		  
		  DECLARE @HavePermission NVARCHAR(500) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,OBJECT_NAME(@@PROCID)))

			IF(@HavePermission = '1')
			BEGIN

				IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				IF(@EntityId IS NULL)
					SET @EntityId = (SELECT TOP(1) Id FROM Entity WHERE CompanyId = @CompanyId AND InactiveDateTime IS NULL AND ParentEntityId IS NULL)

				;WITH Tree AS
				  (
				      SELECT E_Parent.Id AS EntityId
				      FROM Entity E_Parent
				      WHERE (E_Parent.Id = @EntityId) AND InActiveDateTime IS NULL 
				      UNION ALL
				      SELECT E_Child.Id AS EntityChildId
				      FROM Entity E_Child INNER JOIN Tree ON Tree.EntityId = E_Child.ParentEntityId
				      WHERE E_Child.InActiveDateTime IS NULL 
				  )
				  SELECT  T.EntityId,E.EntityName
				          ,E.[IsBranch],E.[IsGroup]
						  ,E.[IsCountry],E.[IsEntity]
						  ,E.[Description],E.[ParentEntityId]
						  ,E.[TimeStamp]
						  ,ISNULL(B.[IsHeadOffice],0) AS IsHeadOffice
						  ,B.[Address]
						  ,B.TimeZoneId
						  ,TZ.TimeZoneName
						  ,B.CurrencyId
						  ,CASE WHEN C.CurrencyCode IS NOT NULL AND C.CurrencyCode <> '' 
						             THEN C.CurrencyName + ' (' + C.CurrencyCode + ')'
								ELSE C.CurrencyName  END AS CurrencyName
						  ,C.CurrencyCode
						  ,B.CountryId
						  ,CASE WHEN CC.CountryCode IS NOT NULL AND CC.CountryCode <> '' 
						             THEN CC.CountryName + ' (' + CC.CountryCode + ')'
								ELSE CC.CountryName END AS CountryName
						  ,B.PayrollTemplateId AS DefaultPayrollTemplateId
						  ,PT.PayrollName
						  ,PT.PayrollShortName
						  ,E.[Description]
				  FROM Tree T
						INNER JOIN Entity E ON E.Id = T.EntityId
						LEFT JOIN Branch B ON B.Id = E.Id AND E.IsBranch = 1
						LEFT JOIN [TimeZone] TZ ON TZ.Id = B.TimeZoneId
						LEFT JOIN Currency C ON C.Id = B.CurrencyId
						LEFT JOIN Country CC ON CC.Id = B.CountryId
						LEFT JOIN PayrollTemplate PT ON PT.Id = B.PayrollTemplateId

			END
			ELSE
				RAISERROR(@HavePermission,11,1)
				 
	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO