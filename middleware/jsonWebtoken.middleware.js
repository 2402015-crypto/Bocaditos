import jwt from 'jsonwebtoken';


export const validateToken = (req, res, next) => {
    const token = req.get('Authorization');
    const secretKey = 'it32';

    if (token == null) {
        return res.sendStatus(401); // Unauthorized
    }

    try {
        jwt.verify(token, secretKey, (err, decoded) => {
            if (err) {
              console.log('Error verifying token:', err);  
              return res.sendStatus(403); // Forbidden
            }

            // 🔧 Inyectar user_id al cuerpo del request
            if (req.body && typeof req.body === 'object') {
                delete req.body.user_id;
                req.body.user_id = decoded.id || decoded.user_id;
            }
        
            req.user = decoded; // Guardar los datos decodificados en la solicitud

            next();
          });
    } catch (error) {
        console.log('Error verifying token:', error);
        return res.status(403).json({
            ok: false,
            message: 'Existe el siguiente problema con la autorización del token: '
        });
    }
}

export const generateJwtToken = (user) => {
    const userData = {
        id: user.id,
        name: user.name,
        email: user.email,
        status: user.status
    }
    try {
        const secretKey = 'it32';
        const expiresIn = '1h';
        const token = jwt.sign(userData, secretKey, { expiresIn: expiresIn });
        console.log('token', token);
        return token;
    } catch (error) {
        console.error('Error generating token:', error);
        throw new Error('Error generating token');
    }   
}