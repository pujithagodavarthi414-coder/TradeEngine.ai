
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.W3rt;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public class VenueBookingRepository : BaseRepository
    {
        public List<VenueOutputModel> GetAllVenues(VenueInputModel venueInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();             
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", venueInputModel.SearchText);
                    vParams.Add("@Id", venueInputModel.Id);
                    return vConn.Query<VenueOutputModel>(StoredProcedureConstants.SpGetAllVenues, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllVenues", "VenueBookingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new List<VenueOutputModel>();
            }   

        }

        public List<OrganisationOutputModel> GetAllOrganisations(OrganisationInputModel organisationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", organisationInputModel.SearchText);
                    if (organisationInputModel != null && !String.IsNullOrEmpty(organisationInputModel.OrganisationId.ToString()))
                    {
                        vParams.Add("@OrganisationId", organisationInputModel.OrganisationId);
                    }
                    return vConn.Query<OrganisationOutputModel>(StoredProcedureConstants.SpGetAllOrganisations, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllOrganisations", "VenueBookingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new List<OrganisationOutputModel>();
            }

        }
    }
}
