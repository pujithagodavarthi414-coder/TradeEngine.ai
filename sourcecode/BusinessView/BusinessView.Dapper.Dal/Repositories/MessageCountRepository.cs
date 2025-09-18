using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class MessageCountRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the MessageCount table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(MessageCountDbEntity aMessageCount)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMessageCount.Id);
					 vParams.Add("@MessageId",aMessageCount.MessageId);
					 vParams.Add("@SenderId",aMessageCount.SenderId);
					 vParams.Add("@ReceiverId",aMessageCount.ReceiverId);
					 vParams.Add("@ChannelId",aMessageCount.ChannelId);
					 vParams.Add("@IsMessageRead",aMessageCount.IsMessageRead);
					 int iResult = vConn.Execute("USP_MessageCountInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the MessageCount table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(MessageCountDbEntity aMessageCount)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aMessageCount.Id);
					 vParams.Add("@MessageId",aMessageCount.MessageId);
					 vParams.Add("@SenderId",aMessageCount.SenderId);
					 vParams.Add("@ReceiverId",aMessageCount.ReceiverId);
					 vParams.Add("@ChannelId",aMessageCount.ChannelId);
					 vParams.Add("@IsMessageRead",aMessageCount.IsMessageRead);
					 int iResult = vConn.Execute("USP_MessageCountUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of MessageCount table.
		/// </summary>
		public MessageCountDbEntity GetMessageCount(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<MessageCountDbEntity>("USP_MessageCountSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the MessageCount table.
		/// </summary>
		 public IEnumerable<MessageCountDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<MessageCountDbEntity>("USP_MessageCountSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the MessageCount table by a foreign key.
		/// </summary>
		public List<MessageCountDbEntity> SelectAllByChannelId(Guid? channelId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ChannelId",channelId);
				 return vConn.Query<MessageCountDbEntity>("USP_MessageCountSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the MessageCount table by a foreign key.
		/// </summary>
		public List<MessageCountDbEntity> SelectAllByMessageId(Guid messageId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@MessageId",messageId);
				 return vConn.Query<MessageCountDbEntity>("USP_MessageCountSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the MessageCount table by a foreign key.
		/// </summary>
		public List<MessageCountDbEntity> SelectAllByReceiverId(Guid? receiverId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ReceiverId",receiverId);
				 return vConn.Query<MessageCountDbEntity>("USP_MessageCountSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the MessageCount table by a foreign key.
		/// </summary>
		public List<MessageCountDbEntity> SelectAllBySenderId(Guid? senderId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@SenderId",senderId);
				 return vConn.Query<MessageCountDbEntity>("USP_MessageCountSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
