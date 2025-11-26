import { PostModel } from '../models/post.js';
import { UserModel } from '../models/user.model.js';

export class PostRoute {
  constructor(app) {
    this.app = app;
  }

  initPostRoutes() {
    this.app.get('/posts', async (req, res) => {
      try {
        const posts = await PostModel.findAll({
          include: [{ model: UserModel, as: 'user' }]
        });
        res.json(posts);
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al obtener los posts' });
      }
    });

    this.app.post('/posts', async (req, res) => {
      try {
        const { user_id, comment } = req.body;
        const post = await PostModel.create({
          user_id,
          comment,
          created_at: new Date().toISOString()
        });
        res.status(201).json(post);
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al crear el post' });
      }
    });
  }
}
