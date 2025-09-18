------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-30 00:00:00.000'
-- Purpose      To Get the Employee Dependent Contacts
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeeDependentContacts] @OperationsPerformedBy ='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE USP_GetEmployeeDependentContacts
(
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @RelationshipId UNIQUEIDENTIFIER = NULL,
   @FirstName NVARCHAR (800) = NULL,
   @LastName NVARCHAR(800) = NULL,
   @OtherRelation NVARCHAR (250) = NULL,
   @HomeTelephone NVARCHAR (250) = NULL,
   @MobileNo NVARCHAR (250) = NULL,
   @WorkTelephone NVARCHAR (250) = NULL,
   @IsEmergencyContact BIT = NULL,
   @IsDependentContact BIT = NULL,
   @AddressStreetOne NVARCHAR (2500) = NULL,
   @AddressStreetTwo NVARCHAR (2500) = NULL,
   @StateOrProvinceId UNIQUEIDENTIFIER = NULL,
   @ZipOrPostalCode NVARCHAR (100) = NULL,
   @CountryId UNIQUEIDENTIFIER = NULL,
   @OriginalId UNIQUEIDENTIFIER = NULL,
   @SearchText NVARCHAR (250) = NULL,
   @IsArchived  BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @SortBy NVARCHAR(100) = NULL,
   @SortDirection VARCHAR(50) = NULL,
   @PageNumber INT = 1,
   @PageSize INT = 10
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

	     IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

		 IF(@RelationshipId = '00000000-0000-0000-0000-000000000000') SET  @RelationshipId = NULL

		 IF(@FirstName = '') SET @FirstName = NULL

		 IF(@LastName = '') SET @LastName = NULL

		 IF(@OtherRelation = '') SET @OtherRelation = NULL

		 IF(@HomeTelephone = '') SET @HomeTelephone = NULL

		 IF(@MobileNo = '') SET @MobileNo = NULL

		 IF(@WorkTelephone = '') SET @WorkTelephone = NULL

		 IF(@IsEmergencyContact = 0) SET @IsEmergencyContact = NULL

		 IF(@IsDependentContact = 0) SET @IsDependentContact = NULL

		 IF(@AddressStreetOne = '') SET @AddressStreetOne = NULL

		 IF(@AddressStreetTwo = '') SET @AddressStreetTwo = NULL

		 IF(@StateOrProvinceId = '00000000-0000-0000-0000-000000000000') SET @StateOrProvinceId = NULL

		 IF (@CountryId = '00000000-0000-0000-0000-000000000000') SET @CountryId = NULL

		 IF(@ZipOrPostalCode = '') SET @ZipOrPostalCode = NULL

		 IF(@OriginalId = '00000000-0000-0000-0000-000000000000') SET @OriginalId = NULL

		 IF (@SearchText = '') SET @SearchText = NULL

		 SET @SearchText = '%'+ RTRIM(LTRIM(@SearchText)) +'%'

		 IF(@SortBy IS NULL) SET @SortBy = 'FirstName'

         IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'

		 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		 SELECT EEC.Id EmployeeDependentId,
		        EEC.EmployeeId,
				E.UserId,
	            EEC.RelationshipId,
				R.RelationShipName Relationship,
	            EEC.FirstName,
	            EEC.LastName,
	            EEC.OtherRelation,
	            EEC.HomeTelephone,
	            EEC.MobileNo,
	            EEC.WorkTelephone,
	            EEC.IsEmergencyContact,
	            EEC.IsDependentContact,
	            EEC.AddressStreetOne,
	            EEC.AddressStreetTwo,
	            EEC.StateOrProvinceId,
	            EEC.ZipOrPostalCode,
	            EEC.CountryId,
	            EEC.CreatedDateTime,
	            EEC.CreatedByUserId,
	            EEC.InActiveDateTime,
	            EEC.[TimeStamp],
	            CASE WHEN EEC.InActiveDateTime IS NULL THEN 0 ELSE 1 END As IsArchived,
				TotalCount = COUNT(*) OVER()
				FROM [EmployeeEmergencyContact] AS EEC
					 JOIN [Employee] E ON E.Id = EEC.EmployeeId AND E.InactiveDateTime IS NULL
                     JOIN [User] U ON U.Id = E.UserId AND U.InactiveDateTime IS NULL
					 LEFT JOIN [RelationShip] R ON R.Id = EEC.RelationshipId AND R.InactiveDateTime IS NULL
				WHERE (@EmployeeId IS NULL OR EEC.EmployeeId = @EmployeeId)
				  AND U.CompanyId = @CompanyId
				  AND (@RelationshipId IS NULL OR EEC.[RelationshipId] = @RelationshipId)
				  AND (@FirstName IS NULL OR EEC.[FirstName] = @FirstName)
				  AND (@LastName IS NULL OR EEC.[LastName] = @LastName)
				  AND (@OtherRelation IS NULL OR EEC.[OtherRelation] = @OtherRelation)
				  AND (@HomeTelephone IS NULL OR EEC.[HomeTelephone] = @HomeTelephone)
				  AND (@MobileNo IS NULL OR EEC.[MobileNo] = @MobileNo)
				  AND (@WorkTelephone IS NULL OR EEC.[WorkTelephone] = @WorkTelephone)
				  AND (@IsEmergencyContact IS NULL OR EEC.[IsEmergencyContact] = @IsEmergencyContact)
				  AND (@IsDependentContact IS NULL OR EEC.[IsDependentContact] = @IsDependentContact)
				  AND (@AddressStreetOne IS NULL OR EEC.[AddressStreetOne] = @AddressStreetOne)
				  AND (@AddressStreetTwo IS NULL OR EEC.[AddressStreetTwo] = @AddressStreetTwo)
				  AND (@StateOrProvinceId IS NULL OR EEC.[StateOrProvinceId]= @StateOrProvinceId)
				  AND (@ZipOrPostalCode IS NULL OR EEC.[ZipOrPostalCode] = @ZipOrPostalCode)
				  AND (@CountryId IS NULL OR EEC.[CountryId] = @CountryId)
				  AND (@OriginalId IS NULL OR EEC.[Id] = @OriginalId)
				  AND (@SearchText IS NULL OR (EEC.FirstName LIKE @SearchText) OR (EEC.LastName LIKE @SearchText) OR (EEC.MobileNo LIKE @SearchText) OR (R.RelationShipName LIKE @SearchText))
				  AND (@IsArchived IS NULL OR (EEC.InActiveDateTime IS NULL AND @IsArchived = 0) OR (EEC.InActiveDateTime IS NOT NULL AND @IsArchived = 1)) 
			   ORDER BY 
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'FirstName') THEN EEC.FirstName
                              WHEN(@SortBy = 'LastName') THEN  EEC.LastName
                              WHEN(@SortBy = 'RelationShip') THEN R.RelationShipName
                              WHEN(@SortBy = 'MobileNo') THEN EEC.MobileNo
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                        CASE WHEN(@SortBy = 'FirstName') THEN EEC.FirstName
                              WHEN(@SortBy = 'LastName') THEN  EEC.LastName
                              WHEN(@SortBy = 'RelationShip') THEN R.RelationShipName
                              WHEN(@SortBy = 'MobileNo') THEN EEC.MobileNo
                          END
                      END DESC
					  OFFSET ((@PageNumber - 1) * @PageSize) ROWS
					  FETCH NEXT @PageSize ROWS ONLY	
		   END

		   ELSE

		       RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

	    THROW

    END CATCH

END
GO          