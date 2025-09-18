using System;
using System.Data;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class StatusReportingAttachmentRepository : BaseRepository
    {
        public bool Delete(Guid fileId)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@FileId", fileId);

                int iResult = vConn.Execute(StoredProcedureConstants.SpStatusReportingAttachmentDeleteByFileId, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }
    }
}
