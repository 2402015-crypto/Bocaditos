import { DataTypes, Model } from 'sequelize';
import { DatabaseConfig } from '../../config/database.config.js';

export class PostModel extends Model {}

PostModel.init(
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    comment: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    created_at: {
      type: DataTypes.STRING(250),
      allowNull: false,
    },
  },
  {
    sequelize: DatabaseConfig,
    modelName: 'Post',
    tableName: 'post',
    timestamps: false,
  }
);


import { UserModel } from './user.model.js';
PostModel.belongsTo(UserModel, { foreignKey: 'user_id', as: 'user' });
UserModel.hasMany(PostModel, { foreignKey: 'user_id', as: 'posts' });

export default PostModel;
