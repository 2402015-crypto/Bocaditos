import express from 'express';
import { Database } from './config/database.config.js';
import { UserRoute } from './app/routes/user.routes.js';
import { PostRoute } from './app/routes/post.routes.js';
import { HealthRoute } from './app/routes/health.routes.js';

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json()); // Para parsear JSON
app.use(express.urlencoded({ extended: true })); // Para parsear formularios

const database = new Database();
await database.connection();

import { UserModel } from './app/models/user.model.js';
import { PostModel } from './app/models/post.js';

await UserModel.sync({ alter: true });
await PostModel.sync({ alter: true });

const userRoute = new UserRoute(app);
userRoute.initUserRoutes();

const postRoute = new PostRoute(app);
postRoute.initPostRoutes();

const healthRoute = new HealthRoute(app);
healthRoute.initHealthRoutes();

app.listen(port, () => {
    console.log(`app listening on port ${port}`);
});
