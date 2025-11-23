import { UserModel } from '../models/user.model.js';
import { authMiddleware, generateToken } from '../middlewares/auth.middleware.js';
import bcrypt from 'bcryptjs';


export class UserRoute { 

    constructor(
        app){ 
        this.app = app; 
    }; 

    initUserRoutes() { 
        this.app.get('/get-users', authMiddleware, async (request, response) => { 
            console.log('get users'); 

            try { 
                const users = await UserModel.findAll(); 
                response.json(users); 

            } catch (error) { 
                console.error('Error fetching users:', error); 
                response.status(500).json({ error: 'Internal Server Error' }); 
            } 
        }); 

        this.app.get('/get-user/:id', authMiddleware, async (request, response) => { 
            console.log('get user by id'); 
            const userId = request.params.id; 

            try { 
                const user = await UserModel.findByPk(userId); 
                if (user) { 
                    response.json(user); 
                } else { 
                    response.status(404).json({ error: 'User not found' }); 
                } 
            } catch (error) { 
                console.error('Error fetching user:', error); 
                response.status(500).json({ error: 'Internal Server Error' }); 
            } 
        }); 

        // Public signup route (no auth required)
        this.app.post('/signup', async (request, response) => {
            console.log('signup attempt', request.body);
            const { name, password, email } = request.body;

            if (!email || !password) {
                return response.status(400).json({ error: 'Email and password are required' });
            }

            try {
                const salt = await bcrypt.genSalt(10);
                const hashed = await bcrypt.hash(password, salt);

                const newUser = await UserModel.create({ name, email, password: hashed });
                return response.status(201).json({ id: newUser.id, email: newUser.email, name: newUser.name });
            } catch (error) {
                console.error('Error creating user:', error);
                return response.status(500).json({ error: 'Internal Server Error' });
            }
        });

        // Admin-protected user creation (keeps original behavior)
        this.app.post('/create-user', authMiddleware, async (request, response) => {
            console.log('create user', request.body);
            const { name, password, email } = request.body;

            try {
                const salt = await bcrypt.genSalt(10);
                const hashed = await bcrypt.hash(password, salt);
                const newUser = await UserModel.create({ name, email, password: hashed });
                response.status(201).json(newUser);
            } catch (error) {
                console.error('Error creating user:', error);
                response.status(500).json({ error: 'Internal Server Error' });
            }
        });

        this.app.post('/login', async (request, response) => {
            console.log('user login attempt');
            const { email, password } = request.body;

            if (!email || !password) {
                return response.status(400).json({ error: 'Email and password are required' });
            }

            try {
                const user = await UserModel.findOne({ where: { email } });
                if (!user) {
                    return response.status(401).json({ error: 'Invalid credentials' });
                }

                const match = await bcrypt.compare(password, user.password);
                if (!match) {
                    return response.status(401).json({ error: 'Invalid credentials' });
                }

                return response.json({
                    user: {
                        id: user.id,
                        name: user.name,
                        email: user.email,
                    },
                    token: generateToken({ id: user.id, email: user.email }),
                });
            } catch (error) {
                console.error('Error validating user:', error);
                return response.status(500).json({ error: 'Internal Server Error' });
            }
        });

        this.app.put('/update-user/:id', authMiddleware, async (request, response) => { 
            console.log('update user');         
            const userId = request.params.id; 
            const { name, email, password, status } = request.body; 

            try { 
                const user = await UserModel.findByPk(userId); 
                if (user) { 
                    user.name = name; 
                    user.email = email; 
                    user.password = password; 
                    user.status = status; 
                    await user.save(); 
                    response.json(user); 
                } else { 
                    response.status(404).json({ error: 'User not found' }); 
                } 
            } catch (error) { 
                console.error('Error updating user:', error); 
                response.status(500).json({ error: 'Internal Server Error' }); 
            } 
        }); 
    }  
} 