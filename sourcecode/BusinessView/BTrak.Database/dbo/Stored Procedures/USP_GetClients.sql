----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-09-24 00:00:00.000'
-- Purpose      To Get All Clients by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetClients] @OperationsPerformedBy = '7506f55e-5830-4eb8-b8ff-ab76983339ea', @ClientId = '7506f55e-5830-4eb8-b8ff-ab76983339ea'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetClients]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @ClientId UNIQUEIDENTIFIER = NULL,
    @ProjectTypeId UNIQUEIDENTIFIER = NULL, 
    @BranchId UNIQUEIDENTIFIER = NULL, 
    @UserId UNIQUEIDENTIFIER = NULL, 
    @EntityId UNIQUEIDENTIFIER = NULL, 
    @SearchText NVARCHAR(250) = NULL,
    @ReferenceType NVARCHAR(1000) = NULL,
    @PageSize INT = 10,
    @PageNumber INT = 1,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50) = NULL,
    @IsArchived BIT = NULL,
	@IsForMail BIT = NULL,
	@IsForAPI BIT = NULL,
	@ClientType UNIQUEIDENTIFIER = NULL,
	@ClientTypeName NVARCHAR(250) = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
           IF(@SearchText = '') SET @SearchText = NULL
           SET @SearchText = '%'+ @SearchText +'%';              
           IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
                   
           IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
           DECLARE @BearerToken NVARCHAR(500) = (SELECT AuthToken from UserAuthToken WHERE UserId=@OperationsPerformedBy)
           IF(@IsArchived IS NULL) SET @IsArchived = 0
           IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
           IF(@ClientId = '00000000-0000-0000-0000-000000000000') SET @ClientId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))      
		   
		   IF(@IsForAPI IS NULL)SET @IsForAPI = 0

           
           IF(@IsForAPI = 0)
		   BEGIN

		       SELECT C.Id AS ClientId,
				  C.Id AS BuyerId,
				  C.UserId,
				  U.FirstName,
				  CK.[NAME] as ClientKycName,
				  REPLACE(REPLACE(REPLACE(CK.FormJson,'##UserId##',@OperationsPerformedBy),'##CompanyId##',@CompanyId),'##ClientId##',C.Id) AS FormJson,
				  CT.ClientTypeName,
				  CT.Id as ClientType,
				  CK.Id as KycDocument,
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
				  CA.Id AS ClientAddressId,
				  CA.CountryId,
				  CA.Zipcode,
				  CA.Street,
				  CA.City,
				  CA.State,
				  CO.CountryName,	
				  CO.CountryCode,	
				  C.CompanyName,
				  C.CompanyWebsite,
				  C.Note,
				  C.BusinesCountryCode ,
				  C.PhoneCountryCode,
				 STUFF((SELECT  ',' +P.ProjectName 
						FROM Project P
						INNER JOIN ClientProjects CP ON CP.ProjectId = P.Id 	
						WHERE C.Id = CP.ClientId FOR XML PATH('')),1,1,''
						)AS ProjectName,
				  STUFF((SELECT  ',' + CONVERT(NVARCHAR(36),UR.RoleId)
						FROM [UserRole] UR
						WHERE UR.UserId = U.Id AND InactiveDateTime IS NULL FOR XML PATH('')),1,1,''
						)AS RoleIds,
				   STUFF((SELECT  ',' + CONVERT(NVARCHAR(36),R.RoleName)
						FROM [UserRole] UR
						JOIN [Role] R ON R.Id = UR.RoleId
						WHERE UR.UserId = U.Id AND UR.InactiveDateTime IS NULL ORDER BY R.RoleName FOR XML PATH('')),1,1,''
						)AS RoleNames,
				  C.CreatedDateTime,
                  C.CreatedByUserId,
                  C.UpdatedDateTime,
                  C.UpdatedByUserId,
                  C.InActiveDateTime,
                  C.[TimeStamp],  
                  CA.[TimeStamp] AS ClientAddressTimeStamp,
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
				  C.TradeTemplateIds,
				  DATEADD(DAY,KycExpiryDays,C.KycSubmittedDate) KycExpireDate,
				  CASE WHEN KycRemindDays IS NOT NULL THEN DATEADD(DAY,-KycRemindDays,DATEADD(DAY,KycExpiryDays,C.KycSubmittedDate)) END KycRemindDate,
				  C.LegalEntityId,
				  C.IsKycSybmissionMailSent,
				  C.KycFormStatusId,
				  CKS.KycStatusName,
				  CKS.StatusName,
				  CKS.StatusColor,
				  CASE WHEN @IsForMail = 1 AND (SELECT COUNT(1) FROM ClientKycFormHistory WHERE NewValue = 'Verified' AND ClientId = @ClientId) = 1 THEN 1 ELSE 0 END IsFirstKYC,
				  ISNULL(C.AddressLine1,'')+', '+ISNULL(C.AddressLine2,'')+ ', '+ISNULL(C.BusinessNumber,'') AS ShipToAddress,
				  (SELECT U.FirstName +' '+ ISNULL(U.SurName,'') FullName, ClientId, LeadFormId AS ContractFormId, FormJson, FormData, CompanyId FROM [ClientContractSubmission] WHERE ClientId = C.Id AND CompanyId = @CompanyId FOR JSON PATH) AS ContractSubmissions,
				  C.BrokerageValue,
				  U.UserAuthenticationId,
                  TotalCount = COUNT(1) OVER()
           FROM Client AS C
		   LEFT JOIN ClientType CT ON CT.Id = C.ClientTypeId
		   LEFT JOIN ClientKycConfiguration CK ON CK.Id = C.ClientKycId
           LEFT JOIN ClientAddress CA ON CA.ClientId = C.Id
           LEFT JOIN ClientProjects CP ON C.Id = CP.ClientId
           LEFT JOIN Country CO ON CO.Id = CA.CountryId 
           LEFT JOIN Project P ON P.Id = CP.ProjectId 
           LEFT JOIN [User] U ON C.UserId = U.Id 
		   LEFT JOIN [TimeZone] T ON T.Id=U.TimeZoneId
		   LEFT JOIN [ClientKycFormStatus] CKS ON CKS.Id = C.KycFormStatusId
           WHERE (@EntityId IS NULL OR C.BranchId IN (SELECT BranchId FROM EntityBranch WHERE InactiveDateTime IS NULL AND EntityId = @EntityId))
                AND (C.CompanyId = @CompanyId) 
				AND (@ReferenceType IS NULL OR (@ReferenceType = 'livesclientslist' AND U.Id NOT IN (SELECT UR.UserId 
				           FROM ROLE R INNER JOIN UserROle UR ON UR.RoleId = R.Id  AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
						       WHERE R.CompanyId = @CompanyId AND R.RoleName = 'Oil Palm Grower'
						   ))) 
                AND U.CompanyId = @CompanyId
				AND (@SearchText IS NULL 
				OR (CONCAT(U.FirstName,' ',U.SurName) LIKE @SearchText) 
				OR C.CompanyName LIKE @SearchText 
				OR CO.CountryName  LIKE @SearchText
				OR U.UserName LIKE @SearchText
				OR C.CreditLimit LIKE @SearchText
				OR C.AvailableCreditLimit LIKE @SearchText
				OR (C.CreditLimit - C.AvailableCreditLimit) LIKE @SearchText
				OR C.BusinessNumber LIKE @SearchText
				)   
				AND (@UserId IS NULL OR C.UserId = @UserId)
                AND ((@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL) 
                    OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL))
                AND (@ClientId IS NULL OR C.Id = @ClientId) 
				AND (@ProjectTypeId IS NULL OR P.ProjectTypeId = @ProjectTypeId)   
				AND (@BranchId IS NULL OR C.BranchId = @BranchId)  
				AND ((@ClientType IS NULL) OR(@ClientType = CT.Id))
				AND ((@ClientTypeName IS NULL) OR (@ClientTypeName = CT.ClientTypeName))
				ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		  	       			CASE WHEN @SortBy = 'Name' THEN CONCAT(U.FirstName,' ',U.SurName) 
								 WHEN @SortBy = 'CompanyName' THEN C.CompanyName 
								 WHEN @SortBy = 'CountryName' THEN CO.CountryName 
								 WHEN @SortBy = 'Email' THEN U.UserName 
								 WHEN @SortBy = 'KYC' THEN CK.[NAME] 
								 WHEN @SortBy = 'Status' THEN CKS.KycStatusName
								 --WHEN @SortBy = 'kycCompleted' THEN U.UserName 
								 WHEN @SortBy = 'CreditLimit' THEN C.CreditLimit
								 WHEN @SortBy = 'AvailableCreditLimit' THEN C.AvailableCreditLimit
								 WHEN @SortBy = 'BusinessNumber' THEN C.BusinessNumber
								 WHEN @SortBy = 'usedCreditLimt' THEN (C.CreditLimit - C.AvailableCreditLimit)
		  	       			     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,C.CreatedDateTime,121) AS sql_variant)
		  	       			END
		  	       	  END ASC,
		  	       	  CASE WHEN @SortDirection = 'DESC' THEN
		  	       			CASE WHEN @SortBy = 'Name' THEN CONCAT(U.FirstName,' ',U.SurName) 
							     WHEN @SortBy = 'CompanyName' THEN C.CompanyName 
								 WHEN @SortBy = 'CountryName' THEN CO.CountryName 
								 WHEN @SortBy = 'Email' THEN U.UserName 
								 WHEN @SortBy = 'KYC' THEN CK.[NAME] 
								 WHEN @SortBy = 'Status' THEN CKS.KycStatusName
								 --WHEN @SortBy = 'kycCompleted' THEN U.UserName 
								 WHEN @SortBy = 'CreditLimit' THEN C.CreditLimit
								 WHEN @SortBy = 'AvailableCreditLimit' THEN C.AvailableCreditLimit
								 WHEN @SortBy = 'BusinessNumber' THEN C.BusinessNumber
								 WHEN @SortBy = 'usedCreditLimt' THEN( C.CreditLimit - C.AvailableCreditLimit)
		  	       			     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,C.CreatedDateTime,121) AS sql_variant)
		  	       			END
		  	       	  END DESC
		   OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		   FETCH NEXT @PageSize ROWS ONLY
		   OPTION(RECOMPILE)
		    END
		   ELSE
		   BEGIN

		   SELECT C.Id AS ClientId,
				  C.Id AS BuyerId,
				  C.UserId,
				  U.FirstName,
				  U.SurName AS LastName,
				   CT.ClientTypeName,
				  CT.Id as ClientType,
				  CONCAT(SUBSTRING(U.FirstName,1,1),' ',SUBSTRING(U.SurName,1,1)) AS AvatarName,
				  CONCAT(U.FirstName,' ',U.SurName)FullName,
				  ISNULL(C.AddressLine1,'')+', '+ISNULL(C.AddressLine2,'')+ ', '+ISNULL(C.BusinessNumber,'') AS ShipToAddress
           FROM Client AS C
		   LEFT JOIN ClientType CT ON CT.Id = C.ClientTypeId
           LEFT JOIN [User] U ON C.UserId = U.Id 
           WHERE (C.CompanyId = @CompanyId)  
                AND U.CompanyId = @CompanyId

		   END


			END

			ELSE  IF(@IsArchived = 0 OR @IsArchived IS NULL)
			BEGIN
				SELECT C.Id AS ClientId,
				  C.UserId,
				  U.FirstName,
				  U.SurName AS LastName,
				  CONCAT(SUBSTRING(U.FirstName,1,1),' ',SUBSTRING(U.SurName,1,1)) AS AvatarName,
				  CONCAT(U.FirstName,' ',U.SurName)FullName,
				  CK.[NAME] as ClientKycName,
				  REPLACE(REPLACE(REPLACE(CK.FormJson,'##BearerToken##','Bearer '+@BearerToken),'##UserId##',@OperationsPerformedBy),'##CompanyId##',@CompanyId) AS FormJson,
				  CT.ClientTypeName,
				  C.KycFormData,
				  CT.Id as ClientType,
				  CK.Id as KycDocument,
				  U.ProfileImage,
				  U.IsActive,
				  U.UserName AS Email,
				  U.MobileNo,
				  U.Password,
				  C.CompanyId,
				  U.TimeZoneId,
				  T.TimeZoneName,
				  CA.Id AS ClientAddressId,
				  CA.CountryId,
				  CA.Zipcode,
				  CA.Street,
				  CA.City,
				  CA.State,
				  CO.CountryName,	
				  CASE WHEN C.ClientKycId IS NULL THEN 0 ELSE 1 END IsClientKyc,
				  C.CompanyName,
				  C.CompanyWebsite,
				  C.Note,			
				  STUFF((SELECT  ',' +P.ProjectName 
						FROM Project P
						INNER JOIN ClientProjects CP ON CP.ProjectId = P.Id 	
						WHERE C.Id = CP.ClientId FOR XML PATH('')),1,1,''
						)AS ProjectName,
				  STUFF((SELECT  ',' + CONVERT(NVARCHAR(36),UR.RoleId)
						FROM [UserRole] UR
						WHERE UR.UserId = U.Id AND InactiveDateTime IS NULL FOR XML PATH('')),1,1,''
						)AS RoleIds,
				  STUFF((SELECT  ',' + CONVERT(NVARCHAR(36),R.RoleName)
						FROM [UserRole] UR
						JOIN [Role] R ON R.Id = UR.RoleId
						WHERE UR.UserId = U.Id AND UR.InactiveDateTime IS NULL ORDER BY R.RoleName FOR XML PATH('')),1,1,''
						)AS RoleNames,
				  C.CreatedDateTime,
                  C.CreatedByUserId,
				  C.UpdatedDateTime,
				  C.UpdatedByUserId,
				  C.InActiveDateTime,
                  C.[TimeStamp],  
				  CA.[TimeStamp] AS ClientAddressTimeStamp,
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
				  CKS.KycStatusName,
				  CKS.StatusName,
				  CKS.StatusColor,
				  C.ContractTemplateIds,
				   ISNULL(C.AddressLine1,'')+', '+ISNULL(C.AddressLine2,'')+ ', '+ISNULL(C.BusinessNumber,'') AS ShipToAddress,
				   DATEADD(DAY,KycExpiryDays,C.KycSubmittedDate) KycExpireDate,
				   CASE WHEN KycRemindDays IS NOT NULL THEN DATEADD(DAY,-KycRemindDays,DATEADD(DAY,KycExpiryDays,C.KycSubmittedDate)) END KycRemindDate,
				   C.BrokerageValue,
				   U.UserAuthenticationId,
                  TotalCount = COUNT(1) OVER()
           FROM Client AS C
		   LEFT JOIN ClientType CT ON CT.Id = C.ClientTypeId
		   LEFT JOIN ClientKycConfiguration CK ON CK.Id = C.ClientKycId
		   LEFT JOIN ClientAddress CA ON CA.ClientId = C.Id
		   LEFT JOIN ClientProjects CP ON C.Id = CP.ClientId
		   LEFT JOIN Country CO ON CO.Id = CA.CountryId 
		   LEFT JOIN Project P ON P.Id = CP.ProjectId 
		   LEFT JOIN Branch B ON B.Id = C.BranchId 
		   LEFT JOIN [User] U ON C.UserId = U.Id 
		   LEFT JOIN [TimeZone] T ON T.Id=U.TimeZoneId
		   LEFT JOIN [ClientKycFormStatus] CKS ON CKS.Id = C.KycFormStatusId
           WHERE (C.InactiveDateTime IS NULL)
                AND (C.CompanyId = @CompanyId)  
					AND (@ReferenceType IS NULL OR (@ReferenceType = 'livesclientslist' AND U.Id NOT IN (SELECT UR.UserId 
				           FROM ROLE R INNER JOIN UserROle UR ON UR.RoleId = R.Id  AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
						       WHERE R.CompanyId = @CompanyId AND R.RoleName = 'Oil Palm Grower'
						   ))) 
                AND (@SearchText IS NULL 
				OR (CONCAT(U.FirstName,' ',U.SurName) LIKE @SearchText) 
				OR C.CompanyName LIKE @SearchText 
				OR CO.CountryName  LIKE @SearchText
				OR U.UserName LIKE @SearchText
				OR C.CreditLimit LIKE @SearchText
				OR C.AvailableCreditLimit LIKE @SearchText
				OR (C.CreditLimit - C.AvailableCreditLimit) LIKE @SearchText
				OR C.BusinessNumber LIKE @SearchText
				)   
				AND (@UserId IS NULL OR C.UserId = @UserId)
                AND (@IsArchived IS NULL OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL) OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL))
                AND (@ClientId IS NULL OR C.Id = @ClientId) 
				AND (@ProjectTypeId IS NULL OR P.ProjectTypeId = @ProjectTypeId)   
				AND (@BranchId IS NULL OR B.Id = @BranchId)  
				AND ((@ClientType IS NULL) OR(@ClientType = CT.Id))
				AND ((@ClientTypeName IS NULL) OR (@ClientTypeName = CT.ClientTypeName))
           ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		  	       			CASE WHEN @SortBy = 'Name' THEN CONCAT(U.FirstName,' ',U.SurName) 
								 WHEN @SortBy = 'CompanyName' THEN C.CompanyName 
								 WHEN @SortBy = 'CountryName' THEN CO.CountryName 
								 WHEN @SortBy = 'Email' THEN U.UserName 
								 WHEN @SortBy = 'KYC' THEN CK.[NAME] 
								 WHEN @SortBy = 'Status' THEN CKS.KycStatusName
								 --WHEN @SortBy = 'kycCompleted' THEN U.UserName 
								 WHEN @SortBy = 'CreditLimit' THEN C.CreditLimit
								 WHEN @SortBy = 'AvailableCreditLimit' THEN C.AvailableCreditLimit
								 WHEN @SortBy = 'BusinessNumber' THEN C.BusinessNumber
								 WHEN @SortBy = 'usedCreditLimt' THEN (C.CreditLimit - C.AvailableCreditLimit)
		  	       			     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,C.CreatedDateTime,121) AS sql_variant)
		  	       			END
		  	       	  END ASC,
		  	       	  CASE WHEN @SortDirection = 'DESC' THEN
		  	       			CASE WHEN @SortBy = 'Name' THEN CONCAT(U.FirstName,' ',U.SurName) 
							     WHEN @SortBy = 'CompanyName' THEN C.CompanyName
								 WHEN @SortBy = 'CountryName' THEN CO.CountryName 
								 WHEN @SortBy = 'Email' THEN U.UserName 
								 WHEN @SortBy = 'KYC' THEN CK.[NAME] 
								 WHEN @SortBy = 'Status' THEN CKS.KycStatusName
								 --WHEN @SortBy = 'kycCompleted' THEN U.UserName 
								 WHEN @SortBy = 'CreditLimit' THEN C.CreditLimit
								 WHEN @SortBy = 'AvailableCreditLimit' THEN C.AvailableCreditLimit
								 WHEN @SortBy = 'BusinessNumber' THEN C.BusinessNumber
								 WHEN @SortBy = 'usedCreditLimt' THEN (C.CreditLimit - C.AvailableCreditLimit)
		  	       			     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,C.CreatedDateTime,121) AS sql_variant)
		  	       			END
		  	       	  END DESC
		   OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		   FETCH NEXT @PageSize ROWS ONLY
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
