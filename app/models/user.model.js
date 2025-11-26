import { Model, DataTypes } from 'sequelize';
import { DatabaseConfig } from '../../config/database.config.js';

export class UserModel extends Model {}

UserModel.init({
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
    field: 'id_usuario',
  },

  name: {
    type: DataTypes.STRING(100),
    allowNull: false,
    field: 'nombre',
  },

  apellido: {
    type: DataTypes.STRING(100),
    allowNull: true,
    field: 'apellido',
  },

  telefono: {
    type: DataTypes.STRING(15),
    allowNull: true,
    field: 'telefono',
  },

  matricula: {
    type: DataTypes.STRING(10),
    allowNull: true,
    field: 'matricula',
  },

  cuatrimestre: {
    type: DataTypes.STRING(10),
    allowNull: true,
    field: 'cuatrimestre',
  },

  email: {
    type: DataTypes.STRING(150),
    allowNull: false,
    unique: { msg: 'Email already in use' },
    validate: {
      isEmail: { msg: 'Must be a valid email address' },
    },
    field: 'correo',
  },

  password: {
    type: DataTypes.STRING(255),
    allowNull: false,
    validate: {
      len: { args: [8, 255], msg: 'Password must be at least 8 characters' },
    },
    field: 'contrasena',
  },

  id_rol: {
    type: DataTypes.INTEGER,
    allowNull: true,
    field: 'id_rol',
  },

  id_escuela: {
    type: DataTypes.INTEGER,
    allowNull: true,
    field: 'id_escuela',
  },

  id_ubicacion: {
    type: DataTypes.INTEGER,
    allowNull: true,
    field: 'id_ubicacion',
  },
}, {
  sequelize: DatabaseConfig,
  modelName: 'Usuario',
  tableName: 'usuarios',
  timestamps: false,
});