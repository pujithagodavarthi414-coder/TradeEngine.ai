using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.SpModels;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class LeadsManagementNoteRepository
    {
        public IEnumerable<LeadNotesSpEntity> GetLeadNotesOnLeadId(Guid? leadId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@LeadId", leadId);

                return vConn.Query<LeadNotesSpEntity>(StoredProcedureConstants.SpLeadNotesDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
