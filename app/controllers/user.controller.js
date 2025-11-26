export const updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email, password } = req.body;
    const user = await UserModel.findByPk(id);
    if (!user) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }
    user.name = name;
    user.email = email;
    user.password = password;
    await user.save();
    res.json({ message: 'Usuario actualizado correctamente', user });
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error', details: error?.errors?.[0]?.message || error.message || error });
  }
};
                                                                                                                                                                                    