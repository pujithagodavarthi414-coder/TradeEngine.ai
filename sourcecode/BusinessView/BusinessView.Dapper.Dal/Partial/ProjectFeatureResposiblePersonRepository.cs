using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;
using Btrak.Dapper.Dal.SpModels;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ProjectFeatureResposiblePersonRepository
    {
        public IEnumerable<ProjectFeatureSpEntity> GetAllFeatureResposiblePersons(Guid projectId,Guid companyId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@ProjectId", projectId);
                vParams.Add("@CompantId", companyId);
                return vConn.Query<ProjectFeatureSpEntity>(StoredProcedureConstants.SpProjectFeatureMembers, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public bool DeleteFeatureDetails(Guid projectId, Guid projectFeatureId)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@ProjectId", projectId);
                vParams.Add("@ProjectFeatureId", projectFeatureId);
                int iResult = vConn.Execute(StoredProcedureConstants.SpDeleteProjectFeature, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }

        public IEnumerable<ProjectFeatureDbEntity> SelectAllFeatures(Guid? projectId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@ProjectId", projectId);
                return vConn.Query<ProjectFeatureDbEntity>(StoredProcedureConstants.SpAllProjectFeature, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public IEnumerable<ProjectFeatureSpEntity> AllProjectFeatures(string scarchFeature)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@FeatureName", scarchFeature);
                return vConn.Query<ProjectFeatureSpEntity>(StoredProcedureConstants.SpAutocompleteFeature, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
