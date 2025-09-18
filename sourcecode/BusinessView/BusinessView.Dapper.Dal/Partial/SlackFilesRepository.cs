using Btrak.Dapper.Dal.Models;
using Dapper;
using System.Data;
using System.Linq;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Partial
{
    public partial class SlackFilesRepository : BaseRepository
    {
        public MessageTypeDbEntity GetFileTypeByFileExtension(string fileExtension)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@MessageType", fileExtension);
                return vConn.Query<MessageTypeDbEntity>(StoredProcedureConstants.SpGetFileType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
    }
}
