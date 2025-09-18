using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class MessageTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the MessageType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(MessageTypeDbEntity aMessageType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMessageType.Id);
					 vParams.Add("@CompanyId",aMessageType.CompanyId);
					 vParams.Add("@MessageTypeName",aMessageType.MessageTypeName);
					 vParams.Add("@CreatedDateTime",aMessageType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aMessageType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aMessageType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aMessageType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_MessageTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the MessageType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(MessageTypeDbEntity aMessageType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMessageType.Id);
					 vParams.Add("@CompanyId",aMessageType.CompanyId);
					 vParams.Add("@MessageTypeName",aMessageType.MessageTypeName);
					 vParams.Add("@CreatedDateTime",aMessageType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aMessageType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aMessageType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aMessageType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_MessageTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of MessageType table.
		/// </summary>
		public MessageTypeDbEntity GetMessageType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<MessageTypeDbEntity>("USP_MessageTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the MessageType table.
		/// </summary>
		 public IEnumerable<MessageTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<MessageTypeDbEntity>("USP_MessageTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
