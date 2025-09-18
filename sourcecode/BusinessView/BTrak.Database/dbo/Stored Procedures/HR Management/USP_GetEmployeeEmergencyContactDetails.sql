-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Employee Emergency Contact details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEmployeeEmergencyContactDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetEmployeeEmergencyContactDetails]
(
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @EmergencyContactId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10,
   @SortBy NVARCHAR(100) = NULL,
   @SortDirection VARCHAR(50)=NULL,
   @IsArchived BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
            IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT[dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

              IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

              IF(@EmergencyContactId = '00000000-0000-0000-0000-000000000000') SET @EmergencyContactId = NULL

              IF(@SearchText = '') SET @SearchText = NULL

              SET @SearchText = '%'+ RTRIM(LTRIM(@SearchText)) +'%'

              IF(@SortBy IS NULL) SET @SortBy = 'FirstName'

              IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'

              SELECT E.Id EmployeeId,
                     EEC.Id EmergencyContactId,
                     E.UserId,
                     U.FirstName UserFirstName,
                     U.SurName UserSurName,
                     U.UserName Email,
                     EEC.RelationshipId,
                     R.RelationShipName Relationship,
                     EEC.FirstName,
                     EEC.LastName,
                     EEC.Id,
                     EEC.OtherRelation,
                     EEC.HomeTelephone,
                     EEC.MobileNo,
                     EEC.WorkTelephone,
                     EEC.IsEmergencyContact,
                     EEC.IsDependentContact,
                     EEC.StateOrProvinceId,
                     S.StateName,
                     EEC.ZipOrPostalCode,
                     EEC.AddressStreetOne,
                     EEC.AddressStreetTwo,
                     EEC.CountryId,
                     C.CountryName,
                     EEC.[TimeStamp],
                     U.FirstName + ' ' + U.SurName UserName,
                     CASE WHEN EEC.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                     TotalCount = COUNT(1) OVER()
                     
              FROM  EmployeeEmergencyContact EEC
                    JOIN [Employee] E ON E.Id = EEC.EmployeeId AND E.InactiveDateTime IS NULL
                    JOIN [User] U ON U.Id = E.UserId AND U.InactiveDateTime IS NULL
                    LEFT JOIN [RelationShip] R ON R.Id = EEC.RelationshipId AND R.InactiveDateTime IS NULL
                    LEFT JOIN [State] S ON S.Id = EEC.StateOrProvinceId AND S.InactiveDateTime IS NULL
                    LEFT JOIN [Country] C ON C.Id = EEC.CountryId AND C.InactiveDateTime IS NULL
              WHERE (@EmployeeId IS NULL OR E.Id = @EmployeeId)
					AND U.CompanyId = @CompanyId
                   AND (@EmergencyContactId IS NULL OR EEC.Id = @EmergencyContactId)
                   AND EEC.IsEmergencyContact = 1
                   AND (@SearchText IS NULL 
                        OR (EEC.FirstName LIKE @SearchText)
                        OR (EEC.LastName LIKE @SearchText)
						OR (R.RelationShipName LIKE @SearchText)
                        OR (EEC.HomeTelephone LIKE @SearchText)
                        OR (EEC.MobileNo LIKE @SearchText)
                        OR (EEC.WorkTelephone LIKE @SearchText))
				   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND EEC.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND EEC.InActiveDateTime IS NULL))
               ORDER BY 
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'FirstName') THEN EEC.FirstName
                              WHEN(@SortBy = 'LastName') THEN  EEC.LastName
                              WHEN(@SortBy = 'RelationShip') THEN R.RelationShipName
                              WHEN(@SortBy = 'HomeTelephone') THEN EEC.HomeTelephone
                              WHEN(@SortBy = 'MobileNo') THEN EEC.MobileNo
                              WHEN(@SortBy = 'WorkTelephone') THEN EEC.WorkTelephone
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                        CASE WHEN(@SortBy = 'FirstName') THEN EEC.FirstName
                              WHEN(@SortBy = 'LastName') THEN  EEC.LastName
                              WHEN(@SortBy = 'RelationShip') THEN R.RelationShipName
                              WHEN(@SortBy = 'HomeTelephone') THEN EEC.HomeTelephone
                              WHEN(@SortBy = 'MobileNo') THEN EEC.MobileNo
                              WHEN(@SortBy = 'WorkTelephone') THEN EEC.WorkTelephone
                          END
                      END DESC
              OFFSET ((@PageNo - 1) * @PageSize) ROWS
              FETCH NEXT @PageSize ROWS ONLY
        END
     END TRY  
     BEGIN CATCH 
        
          THROW
    END CATCH
END