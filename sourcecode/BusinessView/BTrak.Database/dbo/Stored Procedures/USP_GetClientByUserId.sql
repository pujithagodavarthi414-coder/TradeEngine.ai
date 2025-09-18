CREATE PROCEDURE [dbo].[USP_GetClientByUserId]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL,
	@IsForMail BIT = NULL,
	@ClientType UNIQUEIDENTIFIER = NULL,
	@ClientId UNIQUEIDENTIFIER = NULL,
	@ClientTypeName NVARCHAR(250) = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
        DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN
            
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
			DECLARE @BearerToken NVARCHAR(500) = (SELECT AuthToken from UserAuthToken WHERE UserId=@OperationsPerformedBy)
           
           SELECT C.Id AS ClientId,
				  C.Id AS BuyerId,
				  C.UserId,
				  U.FirstName,
				  CT.ClientTypeName,
				  CT.Id as ClientType,
				  CASE WHEN C.KycFormData IS NULL THEN 0 ELSE 1 END IsClientKyc,
				  CASE WHEN C.KycFormData IS NULL THEN 0 ELSE 1 END kycCompleted,
				  U.SurName AS LastName,
				  CONCAT(SUBSTRING(U.FirstName,1,1),' ',SUBSTRING(U.SurName,1,1)) AS AvatarName,
				  CONCAT(U.FirstName,' ',U.SurName)FullName,
				  U.ProfileImage,
				  U.UserName AS Email,
				  U.MobileNo,
				  U.Password,
				  C.CompanyId,
				  U.TimeZoneId,
				  T.TimeZoneName,
				  C.KycFormData,
				  C.CompanyName,
				  C.CompanyWebsite,
				  C.Note,
				  C.CreatedDateTime,
                  C.CreatedByUserId,
                  C.UpdatedDateTime,
                  C.UpdatedByUserId,
                  C.InActiveDateTime,
                  C.[TimeStamp],  
				  C.ClientTypeId AS ClientType,
				  C.CreditLimit,
				  C.[AvailableCreditLimit],
				  C.[AddressLine1],
				  C.[AddressLine2],
				  C.PanNumber,
				  C.BusinessEmail,
				  C.BusinessNumber,
				  C.EximCode,
				  C.GstNumber,
				  C.KycExpiryDays,
				  C.ContractTemplateIds,
				  DATEADD(DAY,KycExpiryDays,C.KYCVerifiedDate) KycExpireDate,
				  CASE WHEN KycRemindDays IS NOT NULL THEN DATEADD(DAY,-KycRemindDays,DATEADD(DAY,KycExpiryDays,C.KYCVerifiedDate)) END KycRemindDate,
				  C.LegalEntityId,
				  C.IsKycSybmissionMailSent,
				  C.KycFormStatusId,
				  ISNULL(C.AddressLine1,'')+', '+ISNULL(C.AddressLine2,'')+ ', '+ISNULL(C.BusinessNumber,'') AS ShipToAddress,
                  TotalCount = COUNT(1) OVER()
           FROM Client AS C
		   LEFT JOIN ClientType CT ON CT.Id = C.ClientTypeId
           LEFT JOIN [User] U ON C.UserId = U.Id 
		   LEFT JOIN [TimeZone] T ON T.Id=U.TimeZoneId
           WHERE (C.CompanyId = @CompanyId)  
				AND ((@UserId IS NULL) OR(@UserId = C.UserId))
                AND U.CompanyId = @CompanyId
				AND ((@ClientType IS NULL) OR(@ClientType = CT.Id))
				AND ((@ClientId IS NULL) OR(@ClientId = C.Id))
				AND ((@ClientTypeName IS NULL) OR (CT.ClientTypeName IN (SELECT * FROM [dbo].[Ufn_StringSplit](@ClientTypeName, ','))))
				
		   OPTION(RECOMPILE)
			END

			ELSE  IF(@IsArchived = 0 OR @IsArchived IS NULL)
			BEGIN
				SELECT C.Id AS ClientId,
				  C.UserId,
				  U.FirstName,
				  U.SurName AS LastName,
				  CONCAT(SUBSTRING(U.FirstName,1,1),' ',SUBSTRING(U.SurName,1,1)) AS AvatarName,
				  CONCAT(U.FirstName,' ',U.SurName)FullName,
				  CT.ClientTypeName,
				  C.KycFormData,
				  CT.Id as ClientType,
				  U.ProfileImage,
				  U.UserName AS Email,
				  U.MobileNo,
				  U.Password,
				  C.CompanyId,
				  U.TimeZoneId,
				  T.TimeZoneName,
				  CASE WHEN C.ClientKycId IS NULL THEN 0 ELSE 1 END IsClientKyc,
				  C.CompanyName,
				  C.CompanyWebsite,
				  C.Note,	
				  C.CreatedDateTime,
                  C.CreatedByUserId,
				  C.UpdatedDateTime,
				  C.UpdatedByUserId,
				  C.InActiveDateTime,
                  C.[TimeStamp],  
				  C.ClientTypeId AS ClientType,
				  C.LeadFormId,
				  C.LeadFormData,
				  C.CreditLimit,
				  C.[AvailableCreditLimit],
				  C.[AddressLine1],
				  C.[AddressLine2],
				  C.PanNumber,
				  C.BusinessEmail,
				  C.BusinessNumber,
				  C.EximCode,
				  C.GstNumber,
				  C.KycExpiryDays,
				  C.LegalEntityId,
				  C.IsKycSybmissionMailSent,
				  C.KycFormStatusId,
				  C.ContractTemplateIds,
				   ISNULL(C.AddressLine1,'')+', '+ISNULL(C.AddressLine2,'')+ ', '+ISNULL(C.BusinessNumber,'') AS ShipToAddress,
				   DATEADD(DAY,KycExpiryDays,C.KYCVerifiedDate) KycExpireDate,
				   CASE WHEN KycRemindDays IS NOT NULL THEN DATEADD(DAY,-KycRemindDays,DATEADD(DAY,KycExpiryDays,C.KYCVerifiedDate)) END KycRemindDate,
                  TotalCount = COUNT(1) OVER()
           FROM Client AS C
		   LEFT JOIN ClientType CT ON CT.Id = C.ClientTypeId
		   LEFT JOIN [User] U ON C.UserId = U.Id 
		   LEFT JOIN [TimeZone] T ON T.Id=U.TimeZoneId
           WHERE (C.InactiveDateTime IS NULL)
				AND ((@UserId IS NULL) OR(@UserId = C.UserId))
                AND (C.CompanyId = @CompanyId)  
				AND ((@ClientType IS NULL) OR(@ClientType = CT.Id))
				AND ((@ClientId IS NULL) OR(@ClientId = C.Id))
				AND ((@ClientTypeName IS NULL) OR (CT.ClientTypeName IN (SELECT * FROM [dbo].[Ufn_StringSplit](@ClientTypeName, ','))))
		   OPTION(RECOMPILE)

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
