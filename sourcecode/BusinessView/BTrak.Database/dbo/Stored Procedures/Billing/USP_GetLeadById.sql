CREATE PROCEDURE [dbo].[USP_GetLeadById]
(
	 @LeadId UNIQUEIDENTIFIER,
     @UserId UNIQUEIDENTIFIER = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
            
              SELECT SG.Id AS SCOId,
              SG.UniqueScoId,
              P.[Name] AS ProductName,
              G.[GradeName],
              CU.FirstName+' '+CU.SurName AS BuyerName,
              CC.GstNumber,
              ISNULL(CC.AddressLine1,'')+', '+ISNULL(CC.AddressLine2,'')+ ', '+ISNULL(CC.BusinessNumber,'') AS ShipToAddress,
              SG.CreatedDateTime AS ScoCreatedDateTime,
              LCS.WeighingSlipDate,
              LCS.FinalQuantityInMT,
              LCS.FinalVehicleNumberOfTransporter,
              LCS.FinalMobileNumberOfTruckDriver,
              LCS.FinalPortId,
              LCS.FinalDrums,
              LCS.FinalBLNumber,
              LCS.WeighingSlipNumber,
              LCS.WeighingSlipPhoto,
              LCS.UploadedOther,
              LCS.WhUpdatedUserId,
              LCS.WhUpdatedDateTime,
              LCS.CompanyId,
              WH.FirstName+' '+WH.SurName AS whEmployeeName,
              TotalCount = COUNT(1) OVER()
            FROM LeadContactSubmissions LCS
            INNER JOIN Client CC ON CC.Id = LCS.ClientId
            INNER JOIN [User] CU ON CU.Id = CC.UserId
            INNER JOIN MasterProduct P ON P.Id=LCS.ProductId
            INNER JOIN [BillingGrade] G ON G.Id=LCS.GradeId
            INNER JOIN [ClientAddress] CA ON CA.ClientId = LCS.ClientId
            LEFT JOIN SCOGenerations SG ON SG.LeadSubmissionId=LCS.Id AND SG.InActiveDateTime IS NULL
            LEFT JOIN [User] WH ON WH.Id = @UserId
			WHERE LCS.Id = @LeadId
            ORDER BY LCS.CreatedDatetime DESC
 
    END TRY
    BEGIN CATCH
        
        THROW
 
    END CATCH 
 END
GO
