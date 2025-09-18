using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class LeadRepository
    {
        public void UpdateLeadNextAction(Guid? leadId, Guid companyId, DateTime nextAction)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@LeadId", leadId);
                vParams.Add("@CompanyId", companyId);
                vParams.Add("@NextAction", nextAction);

                vConn.Execute(StoredProcedureConstants.SpUpdateLeadNextAction, vParams, commandType: CommandType.StoredProcedure);
            }
        }

        public void UpdateLeadArchiveStatus(Guid? leadId, Guid companyId, bool isArchive)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@LeadId", leadId);
                vParams.Add("@CompanyId", companyId);
                vParams.Add("@IsArchive", isArchive);

                vConn.Execute(StoredProcedureConstants.SpUpdateIsArchive, vParams, commandType: CommandType.StoredProcedure);
            }
        }

        public IEnumerable<LeadDbEntity> SearchLeads(Guid? leadId, Guid companyId, int pageSize, int skip, string searchText, string orderByColumnName, bool? orderByDirection,bool isArchive)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@LeadId", leadId);
                vParams.Add("@CompanyId", companyId);
                vParams.Add("@PageSize", pageSize);
                vParams.Add("@skip", skip);
                vParams.Add("@SearchText", searchText);
                vParams.Add("@OrderByColumnName", orderByColumnName);
                vParams.Add("@OrderByDirectionAsc", orderByDirection);
                vParams.Add("@IsArchive", isArchive);

                return vConn.Query<LeadDbEntity>(StoredProcedureConstants.SpSearchLeads, vParams, commandType: CommandType.StoredProcedure)
                    .ToList();
            }
        }
    }
}
