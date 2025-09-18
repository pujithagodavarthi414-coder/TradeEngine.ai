using System;
using System.Data;
using Dapper;
using System.Collections.Generic;
using Btrak.Models;
using System.Linq;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeDocumentRepository : BaseRepository
    {
        public IList<EmployeeAttachmentsmodel> GetEmployeeAttachments(Guid employeeId, Guid? fileId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@EmployeeId", employeeId);
                vParams.Add("@FileId", fileId);

                return vConn.Query<EmployeeAttachmentsmodel>(StoredProcedureConstants.SpGetHrmEmployeeAttachments, vParams, commandType: CommandType.StoredProcedure)
                     .ToList();
            }
        }     

        public EmployeeAttachmentsmodel GetEmployeeAttachmentDetails(Guid employeeId, Guid? fileId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@EmployeeId", employeeId);
                vParams.Add("@FileId", fileId);

                return vConn.Query<EmployeeAttachmentsmodel>(StoredProcedureConstants.SpGetHrmEmployeeAttachments, vParams, commandType: CommandType.StoredProcedure)
                     .FirstOrDefault();
            }
        }

        public bool DeleteEmployeeAttachment(Guid employeeId, Guid fileId)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@EmployeeId", employeeId);
                vParams.Add("@FileId", fileId);
                int iResult = vConn.Execute(StoredProcedureConstants.SpEmployeeDocumentDelete, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }
    }
}
