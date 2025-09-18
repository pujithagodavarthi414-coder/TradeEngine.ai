CREATE PROCEDURE [dbo].[USP_GetGrERomande]
(
	@Id UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@FileUrl NVARCHAR(250) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF(@HavePermission = '1')
		BEGIN				
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF(@SearchText = '') SET @SearchText = NULL
		   
			SET @SearchText = '%'+ @SearchText +'%'

			 SELECT G.Id,
				    G.SiteId,
					S.[Name] AS SiteName,
					S.Email,
					GrdId,
					GR.[Name] AS GRDName,
					BA.Id AS BankId,
					BA.BankAccountName,
					[Month],
					G.StartDate,
					G.EndDate,
					G.Term,
					[Year],
					Production,
					Reprise,
					AutoConsumption,
					Facturation,
					GridInvoice,
					GridInvoiceDate,
					CASE WHEN GR.[Name] = 'GroupeE' THEN 1 ELSE 0 END AS IsGre,
					HauteTariff,
					BasTariff,
					TariffTotal,
					[Distribution],
					GreFacturation,
					GreTotal,
					AdministrationRomandeE,
					ConfirmDetailsfromGrid,
					AutoConsumptionSum,
					FacturationSum,
					SubTotal,
					TVA,
					TVAForSubTotal,
					Total,
					PRATotal,
					PRAFields,
					DFFields,
					G.AutoCTariff,
					InvoiceUrl,
					GenerateInvoice,
					G.CompanyId,
					G.CreatedByUserId,
					G.CreatedDateTime,
					ISNULL(G.GridInvoiceName, '') AS GridInvoiceName,
					--SO.[Solar Log Value] AS SolarLogValueKwh,
					SL.SolarLogValue * 1000 AS SolarLogValueKwh,
					[PVSystem] AS PlannedSystem,
					PlannedAutoC,
					ISNULL(OutStandingAmount, 0) AS OutStandingAmount,
					MessageType,
					U.FirstName + ' '+ U.SurName AS CreatedBy,
					G.[TimeStamp]
			FROM [dbo].[GrERomande] AS G
			INNER JOIN [User] AS U ON U.Id = G.CreatedByUserId
			INNER JOIN GRD AS GR ON GR.Id = G.GrdId
			INNER JOIN BankAccount AS BA ON BA.Id = G.BankId
			INNER JOIN [site] AS S ON S.Id = G.SiteId
			LEFT JOIN (SELECT SiteId,SelectedDate,SUM(SolarLogValue)SolarLogValue FROM SolarLogForm SL GROUP BY SiteId,SelectedDate)  AS SL ON FORMAT(SL.SelectedDate, 'MMMM-yy') = FORMAT(G.[Month], 'MMMM-yy') AND SL.SiteId = G.SiteId 
			LEFT JOIN (SELECT JSON_VALUE(GFS.FormJson, '$.site')[Site],
				FORMAT(CAST(JSON_VALUE(GFS.FormJson, '$.date') AS date) ,'MMM-yy') MonthYear ,
				SUM (CAST(JSON_VALUE(GFS.FormJson, '$.pvSystem') AS float)) [PVSystem],0 [Solar Log Value],
				SUM (CAST(JSON_VALUE(GFS.FormJson, '$.plannedAutoC') AS float)) PlannedAutoC
				FROM GenericFormSubmitted GFS
				INNER JOIN GenericForm AS GF ON GF.Id = GFS.FormId
				INNER JOIN CustomApplication AS CA ON CA.Id = GFS.CustomApplicationId
				WHERE CA.CustomApplicationName = 'Photon' AND GF.FormName = 'Planned Values for site'
				GROUP BY JSON_VALUE(GFS.FormJson, '$.site'),
				FORMAT(CAST(JSON_VALUE(GFS.FormJson, '$.date') AS date) ,'MMM-yy') 
				) AS PV ON PV.[Site] = S.[Name] AND PV.MonthYear = FORMAT(CAST(G.[Month] AS date) ,'MMM-yy')
			--LEFT JOIN (SELECT JSON_VALUE(GFS.FormJson, '$.site')[Site],
			--	FORMAT(CAST(JSON_VALUE(GFS.FormJson, '$.date') AS DATE),'MMM-yy') MonthYear ,
			--	0 [PV System],
			--	SUM ((CAST(JSON_VALUE(GFS.FormJson, '$.solarLogValueKwh') AS float))) [Solar Log Value]
			--	FROM GenericFormSubmitted GFS
			--	INNER JOIN GenericForm AS GF ON GF.Id = GFS.FormId
			--	INNER JOIN CustomApplication AS CA ON CA.Id = GFS.CustomApplicationId
			--	WHERE CA.CustomApplicationName = 'Photon' AND GF.FormName = 'Solar Log Form'
			--	group by JSON_VALUE(GFS.FormJson, '$.site'),
			--	FORMAT(CAST(JSON_VALUE(GFS.FormJson, '$.date') AS DATE),'MMM-yy')
			--	) AS SO ON SO.[Site] = S.[Name] AND SO.MonthYear = FORMAT(CAST(G.[Month] AS date) ,'MMM-yy')
			WHERE G.CompanyId = @CompanyId
			AND G.InActiveDateTime IS NULL
			AND (@Id IS NULL OR G.Id = @Id)
				AND	(@SearchText IS NULL
					OR GridInvoice LIKE @SearchText
					OR G.AutoCTariff LIKE @SearchText
					OR [Month] LIKE @SearchText
					OR G.Term LIKE @SearchText
					OR[Year] LIKE @SearchText
					OR Production LIKE @SearchText
					OR Reprise LIKE @SearchText
					OR Facturation LIKE @SearchText
					OR HauteTariff LIKE @SearchText
					OR BasTariff LIKE @SearchText
					OR [Distribution] LIKE @SearchText
					OR GreFacturation LIKE @SearchText
					OR AdministrationRomandeE LIKE @SearchText
					OR (REPLACE(CONVERT(NVARCHAR,GridInvoiceDate,106),' ','-')) LIKE @SearchText
					OR (REPLACE(CONVERT(NVARCHAR,G.StartDate,106),' ','-')) LIKE @SearchText
					OR (REPLACE(CONVERT(NVARCHAR,G.EndDate,106),' ','-')) LIKE @SearchText)
			AND (@FileUrl IS NULL OR InvoiceUrl LIKE '%' + @FileUrl + '%')

		END
		ELSE   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END